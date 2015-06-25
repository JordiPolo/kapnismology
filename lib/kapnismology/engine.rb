module Kapnismology
  class Engine < ::Rails::Engine
    initializer "kapnismology.add_autoload_paths", before: :set_autoload_paths do |app|
      app.config.eager_load_paths += Dir["#{app.config.root}/lib/**/*"]
    end

   # config.eager_load_paths += Dir["#{app.config.root}/lib/**/*"]
    isolate_namespace Kapnismology
    Rails.application.routes.draw do
      mount Kapnismology::Engine, at: "/smoke_test"
    end

  end

end