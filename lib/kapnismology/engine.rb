module Kapnismology
begin
  class Engine < ::Rails::Engine
    initializer "kapnismology.add_autoload_paths", before: :set_autoload_paths do |app|
      app.config.eager_load_paths += Dir["#{app.config.root}/lib/**/*"]
    end

    isolate_namespace Kapnismology
  end

  class Routes
    def self.insert!(path)
      if defined?(Kapnismology) == false
        raise 'require kapnismology before trying to insert routes'
      end
      Rails.application.routes.draw do
        mount Kapnismology::Engine, at: path
      end
    end
  end
rescue NameError => e
  puts "Incompatible Rails version #{e}"
end
end