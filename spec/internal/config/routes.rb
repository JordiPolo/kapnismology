if defined?(Rails)
  require 'kapnismology/engine'

  Rails.application.routes.draw do
    mount Kapnismology::Engine, at: '/smoke_test'
  end
end
