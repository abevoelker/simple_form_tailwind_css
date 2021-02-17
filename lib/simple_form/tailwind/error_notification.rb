module SimpleForm
  module Tailwind
    class ErrorNotification < SimpleForm::ErrorNotification
      def render
        if has_errors?
          color = @options.fetch(:color, "red")
          icon = @options.fetch(:icon, "x-circle")

          template.content_tag(
            :div,
            (
              template.content_tag(
                :div,
                (
                  template.content_tag(
                    :div,
                    template.heroicon(icon, options: { class: "h-5 w-5 text-#{color}-400" }),
                    class: "flex-shrink-0"
                  ) + template.content_tag(
                    :div,
                    template.content_tag(
                      :p,
                      error_message,
                      class: "text-sm text-#{color}-700"
                    ),
                    class: "ml-3"
                  )
                ),
                class: "flex"
              )
            ),
            class: "bg-#{color}-50 border-l-4 border-#{color}-400 p-4"
          )
        end
      end
    end
  end
end
