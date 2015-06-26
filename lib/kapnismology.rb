#Engines blow up when being autoloaded by Rails and at the same time loaded by other gems
unless defined?(Kapnismology::Engine)
  require "kapnismology/engine"
end
require 'contracts'
require 'kapnismology/result'
require 'kapnismology/evaluation'
require 'kapnismology/rake_task'
require 'kapnismology/smoke_test'
