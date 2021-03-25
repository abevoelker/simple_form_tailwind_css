require "rails/generators"

module SimpleForm::Tailwind
  module Generators # :nodoc:
    class InstallGenerator < ::Rails::Generators::Base # :nodoc:
      desc "Creates SimpleForm initializer using default Tailwind components"

      def self.default_generator_root
        File.dirname(__FILE__)
      end

      def copy_initializer
        copy_file "simple_form.rb", "config/initializers/simple_form.rb"
      end
    end
  end
end
