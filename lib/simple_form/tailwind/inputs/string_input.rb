# frozen_string_literal: true
require "simple_form/inputs/string_input"
require "simple_form/tailwind/overwrite_class_with_error_or_valid_class"

module SimpleForm
  module Tailwind
    module Inputs
      class StringInput < SimpleForm::Inputs::StringInput
        include SimpleForm::Tailwind::OverwriteClassWithErrorOrValidClass

        def input(*args, &blk)
          if has_errors?
            template.content_tag(:div, (
              super + (
                template.content_tag(
                  :div,
                  template.heroicon("exclamation-circle", options: { class: "h-5 w-5 text-red-500" }),
                  class: "absolute inset-y-0 right-0 pr-3 flex items-center pointer-events-none"
                )
              )
            ), class: "mt-1 relative rounded-md shadow-sm")
          else
            template.content_tag(:div, super, class: "mt-1")
          end
        end
      end
    end
  end
end
