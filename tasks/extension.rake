if defined? JRUBY_VERSION
  require 'rake/javaextensiontask'
  Rake::JavaExtensionTask.new('red25519_engine') do |ext|
    ext.ext_dir = 'ext/red25519'
  end
else
  require 'rake/extensiontask'

  Rake::ExtensionTask.new('red25519_engine') do |ext|
    ext.ext_dir = 'ext/red25519'
  end
end
