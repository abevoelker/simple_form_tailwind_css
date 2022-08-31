module SimpleForm
  module Tailwind
    class ErrorNotification < SimpleForm::ErrorNotification
      def render
        if @options[:color]
          warn "WARNING SimpleForm::Tailwind's :color error_notification option has " \
            "been removed due to incompatibility with Tailwind's JIT. " \
            "Please replace with the new :icon_classes, :message_classes, and " \
            ":border_classes options (see README for an example)."
        end

        if has_errors?
          icon_classes = @options.fetch(:icon_classes, "h-5 w-5 text-red-400")
          message_classes = @options.fetch(:message_classes, "text-sm text-red-700")
          border_classes = @options.fetch(:border_classes, "bg-red-50 border-l-4 border-red-400 p-4")
          icon = @options.fetch(:icon, "x-circle")

          template.content_tag(
            :div,
            (
              template.content_tag(
                :div,
                (
                  template.content_tag(
                    :div,
                    template.heroicon(icon, options: { class: icon_classes }),
                    class: "flex-shrink-0"
                  ) + template.content_tag(
                    :div,
                    template.content_tag(
                      :p,
                      error_message,
                      class: message_classes
                    ),
                    class: "ml-3"
                  )
                ),
                class: "flex"
              )
            ),
            class: border_classes
          )
        end
      end
    end
  end
end
