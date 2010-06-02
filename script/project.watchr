#!/usr/bin/env jruby

require 'growl'

def growl(message)
  if Growl.installed?
    Growl.notify_ok(message, :title => "Features")
  else
    puts message
  end
end

def growl_result(message)
  msg, meth = if $?.success?
    ["Successful: #{message}", :notify_ok]
  else
    ["Failed: #{message}", :notify_error]
  end
  if Growl.installed?
    Growl.send(meth, msg, :title => "Features")
  else
    puts message
  end
end

def run(cmd)
  puts(cmd)
  system(cmd)
  puts "*** #{Time.now} ***\n*** Exited with #{$?.exitstatus}\n\n"
end

def run_feature(pattern)
  if !(files = Dir["features/*#{pattern}*.feature"]).empty?
    cucumber(files)
  end
end

def run_all_features
  cucumber("features")
end

def cucumber(*args)
  cmdlist = args.flatten.join(' ')
  growl("cucumber #{cmdlist}")
  run("jruby script/cucumber --drb #{cmdlist}")
  growl_result("cucumber #{cmdlist}")
end

def spawn_spork
  @spork ||= Thread.new do
    growl "Starting spork"
    system 'jruby script/spork'
    java.lang.System.exit(0)
  end
end

growl "Loading #{Pathname.new(__FILE__).relative_path_from(Pathname.new(Dir.pwd))}"
spawn_spork

watch('^features/(.*)\.feature') {|md| run_feature(md[1]) } # re-run feature
watch('^features/step_definitions/(.*)_steps\.rb') {|md| run_feature(md[1]) } # re-run feature
watch('^lib/(.*)\.rb')              {|md| run_feature(md[1]) } # watch all libs
watch('^app/models/(.*)\.rb')       {|md| run_feature(md[1]) } # watch all models
watch('^app/controllers/(.*)_controller\.rb')  {|md| run_feature(md[1]) } # watch all controllers
watch('^app/helpers/(.*)_helper\.rb')      {|md| run_feature(md[1]) } # watch all helpers
watch('^app/views/([^/]+)/.*\.erb') {|md| run_feature(md[1]) } # watch views
watch('application_([^/]+)\.rb') { run_all_features }
watch('^config/.*\.rb') { run_all_features }
watch('^features/support/.*\.rb') { run_all_features }
