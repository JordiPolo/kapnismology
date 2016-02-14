# Rails support, this may need changes if Rails change internals
module Kapnismology
  begin
    # Rails engine to automatically load our code and smoke tests libraries
    class Engine < ::Rails::Engine
      initializer 'kapnismology.add_autoload_paths', before: :set_autoload_paths do |app|
        app.config.eager_load_paths += Dir["#{app.config.root}/lib/**/*"]
      end

      isolate_namespace Kapnismology
    end

    # Inserts the engine (the smoketest_controller) into a given path.
    # TODO: how to automatically do this without the user needing to insert?
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
