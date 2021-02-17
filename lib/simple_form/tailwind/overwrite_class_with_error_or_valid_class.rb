module SimpleForm
  module Tailwind
    # This module can be mixed in to inputs to change the default
    # :error_class and :valid_class option behavior to *overwrite* the existing
    # :class value when there's an error or the model is valid, instead of
    # *adding* these classes to the :class value.
    module OverwriteClassWithErrorOrValidClass
      def set_input_classes(wrapper_options)
        wrapper_options = wrapper_options.dup
        error_class     = wrapper_options.delete(:error_class)
        valid_class     = wrapper_options.delete(:valid_class)

        if error_class.present? && has_errors?
          wrapper_options[:class] = error_class
        end

        if valid_class.present? && valid?
          wrapper_options[:class] = valid_class
        end

        wrapper_options
      end
    end
  end
end
