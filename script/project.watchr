#!/usr/bin/env jruby

growl "Loading #{Pathname.new(__FILE__).relative_path_from(Pathname.new(Dir.pwd))}"
spawn_spork
trap_exit

watch('^features/(.*)\.feature') {|md| run_feature(md[1]) } # re-run feature
watch('^features/step_definitions/(.*)_steps\.rb') {|md| run_feature(md[1]) } # re-run feature
watch('^features/support/.*\.rb') { run_all_features }
watch('^spec/(.*)_spec\.rb') {|md| run_spec(md[1]) } # re-run feature
watch('^lib/(.*)\.rb')              {|md| run_both(md[1]) } # watch all libs
watch('^app/models/(.*)\.rb')       {|md| run_both(md[1]) } # watch all models
watch('^app/controllers/(.*)_controller\.rb')  {|md| run_feature(md[1]); run_spec(md[1], 'controllers') } # watch all controllers
watch('^app/helpers/(.*)_helper\.rb')      {|md| run_feature(md[1]); run_spec(md[1], 'helpers') } # watch all helpers
watch('^app/views/([^/]+)/.*\.erb') {|md| run_feature(md[1]); run_spec(md[1], 'views') } # watch views
watch('application_([^/]+)\.rb') { run_all_features }
watch('^config/.*\.rb') { run_all_features; run_all_specs }
