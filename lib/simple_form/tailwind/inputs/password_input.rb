# frozen_string_literal: true
module SimpleForm
  module Tailwind
    module Inputs
      class PasswordInput < SimpleForm::Inputs::PasswordInput
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
