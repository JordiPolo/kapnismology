# Engines blow up when being autoloaded by Rails and at the same time loaded by other gems
require 'kapnismology/engine' unless defined?(Kapnismology::Engine)
require 'kapnismology/result'
require 'kapnismology/evaluation'
require 'kapnismology/evaluation_collection'
require 'kapnismology/rake_task'
require 'kapnismology/smoke_test'
