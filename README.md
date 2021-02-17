# SimpleForm::Tailwind

Tailwind components for [Simple Form][]

## Installation

First, install and set up [Simple Form][].

Then add this gem to your application's Gemfile:

```ruby
gem "simple_form_tailwind", github: "abevoelker/simple_form_tailwind"
```

And then execute:

```
$ bundle install
```

Finally, modify your Simple Form initializer:

```
# config/initializers/simple_form.rb

config.wrappers :tailwind_string_input, tag: 'div', class: '', error_class: '', valid_class: '' do |b|
  b.use :html5
  b.use :placeholder
  b.optional :maxlength
  b.optional :minlength
  b.optional :pattern
  b.optional :min_max
  b.optional :readonly

  b.use :label, class: "block text-sm font-medium text-gray-700"
  b.use :input,
    class: 'appearance-none block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm placeholder-gray-400 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm',
    error_class: 'block w-full pr-10 border-red-300 text-red-900 placeholder-red-300 focus:outline-none focus:ring-red-500 focus:border-red-500 sm:text-sm rounded-md'
  b.use :full_error, wrap_with: { tag: 'p', class: 'mt-2 text-sm text-red-600' }
end

config.wrappers :string_corner_hint, tag: :div do |b|
  b.use :html5
  b.use :placeholder
  b.optional :maxlength
  b.optional :minlength
  b.optional :pattern
  b.optional :min_max
  b.optional :readonly

  b.wrapper tag: :div, class: "flex justify-between", error_class: nil, valid_class: nil do |c|
    c.use :label, class: "block text-sm font-medium text-gray-700"
    c.use :hint,  wrap_with: { tag: :span, class: "text-sm text-gray-500" }
  end

  b.use :input,
    class: "appearance-none block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm placeholder-gray-400 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm",
    error_class: "block w-full pr-10 border-red-300 text-red-900 placeholder-red-300 focus:outline-none focus:ring-red-500 focus:border-red-500 sm:text-sm rounded-md"
  b.use :full_error, wrap_with: { tag: "p", class: "mt-2 text-sm text-red-600" }
end

config.wrapper_mappings = {
  string: :tailwind_string_input,
}

# Simple Form generates a lot of extra classes and other junk that we don't
# want when using Tailwind. These settings disable them:
config.button_class = nil
config.default_form_class = nil
config.form_class = nil
config.generate_additional_classes_for = []
config.label_text = lambda { |label, required, explicit_label| "#{label}" }
```

## Usage

Here's an example form demonstrating usage:

```erb
<%= simple_form_for(@foo, builder: SimpleForm::Tailwind::FormBuilder, html: { class: "space-y-6" }) do |f| %>
  <%= f.input :name, wrapper: :tailwind_string_input, autocomplete: "name", placeholder: "Alex Smith", label: "Display name" %>
  <%= f.input :email, wrapper: :tailwind_string_input, autocomplete: "email", placeholder: "asmith@example.com", label: "Email address" %>
  <div>
    <%= f.button :button, "Get started", class: "w-full flex justify-center py-2 px-4 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500" %>
  </div>
<% end %>
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

[Simple Form]: https://github.com/heartcombo/simple_form
