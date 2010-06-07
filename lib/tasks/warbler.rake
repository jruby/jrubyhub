Warbler::Task.new

obfuscated = Warbler::Task.new(:obfuscated)
obfuscated.config.war_name = "#{obfuscated.config.war_name}_obfuscated"
obfuscated.config.features = %w(executable)

namespace :obfuscated do
  ruby_app_sources = FileList[*obfuscated.config.dirs.map{|d| "#{d}/**/*.rb"}]

  task :compile_rb do |t|
    # Need to use the version of JRuby in the application to compile it
    sh "java -classpath #{obfuscated.config.java_libs.join(File::PATH_SEPARATOR)} org.jruby.Main -S jrubyc \"#{ruby_app_sources.join('" "')}\""
  end

  task :replace_sources do
    obfuscated.config.excludes = ruby_app_sources
    war = obfuscated.war
    def war.add_app_file(config,path, file)
      files[apply_pathmaps(config, path, :application)] = file
    end
    ruby_app_sources.each do |rb|
      obfuscated.war.add_app_file(obfuscated.config, rb,
                                  StringIO.new("require __FILE__.sub(/\.rb$/, '.class')"))
    end
  end

  task :files => [:compile_rb, :replace_sources]

  task :clean do
    rm_f FileList['**/*.class']
  end
end

