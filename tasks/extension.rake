require 'rake/extensiontask'

Rake::ExtensionTask.new('red25519_engine') do |ext|
  ext.ext_dir = 'ext/red25519'
end
