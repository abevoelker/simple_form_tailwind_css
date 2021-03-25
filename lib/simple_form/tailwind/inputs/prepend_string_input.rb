# frozen_string_literal: true
require "simple_form/inputs/string_input"
require "simple_form/tailwind/overwrite_class_with_error_or_valid_class"

module SimpleForm
  module Tailwind
    module Inputs
      class PrependStringInput < SimpleForm::Inputs::StringInput
        include SimpleForm::Tailwind::OverwriteClassWithErrorOrValidClass

        def input(*args, &blk)
          input_html_options[:type] ||= "text"

          super
        end

        def prepend(wrapper_options = nil)
          template.content_tag(:span, options[:prepend], class: "inline-flex items-center px-3 rounded-l-md border border-r-0 border-gray-300 bg-gray-50 text-gray-500 sm:text-sm")
        end
      end
    end
  end
end
