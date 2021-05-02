# SimpleForm::Tailwind

Tailwind components for [Simple Form][]

## Installation

First, install and setup [Tailwind](https://github.com/rails/tailwindcss-rails) ([helpful additional steps here](https://github.com/rails/tailwindcss-rails/issues/25)), [Simple Form][], and the [heroicon gem](https://github.com/bharget/heroicon).

Then add this gem to your application's Gemfile:

```ruby
gem "simple_form_tailwind", github: "abevoelker/simple_form_tailwind"
```

And then execute:

```
$ bundle install
```

Finally, overwrite your Simple Form initializer with ours:

```
$ rails g simple_form:tailwind:install
```

## Usage

Here's an example form demonstrating usage:

```erb
<%= simple_form_for(@foo, builder: SimpleForm::Tailwind::FormBuilder) do |f| %>
  <%= f.error_notification %>
  <%= f.input :name, autocomplete: "name", placeholder: "Alex Smith", label: "Display name" %>
  <%= f.input :email, autocomplete: "email", placeholder: "asmith@example.com", label: "Email address" %>
  <div>
    <%= f.button :button, "Get started", class: "w-full flex justify-center py-2 px-4 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500" %>
  </div>
<% end %>
```

One important difference when using Tailwind form builder versus Simple Form's default form builder is that `:error_class` and `:valid_class` classes **completely overwrite** `:class` rather than add to it. This is more amenable to the Tailwind way of doing things, as the "error" state may have completely different classes than the form component in its "default" state.

## Components

### Default

```
<%= f.input :display_name, placeholder: "Alex Smith", hint: "Max 255 characters" %>
```

![Default component preview](/docs/images/components/default.png?raw=true)

With an error, it looks like this:

![Default component with error preview](/docs/images/components/default_with_error.png?raw=true)

### Corner hint

```
<%= f.input :display_name, wrapper: "corner_hint", placeholder: "Alex Smith", hint: "Max 255 characters" %>
```

![Corner hint component preview](/docs/images/components/corner_hint.png?raw=true)

### Prepend

```
<%= f.input :twitter_username, as: "prepend_string", prepend: "twitter.com/", placeholder: "jack" %>
```

![Prepend component preview](/docs/images/components/prepend.png?raw=true)

### Append

```
<%= f.input :substack_username, as: "append_string", append: ".substack.com", placeholder: "graymirror" %>
```

![Append component preview](/docs/images/components/append.png?raw=true)

### Error notification

Simple Form's error notification is supported, defaulting to a red color with x-circle Heroicon:

```erb
<%= f.error_notification %>
```

![Red error notification](/docs/images/error_notification_red.png?raw=true)

You can customize the color and icon used:

```erb
<%= f.error_notification color: "blue", icon: "information-circle" %>
```

![Blue error notification](/docs/images/error_notification_blue.png?raw=true)

The message and other parameters can be customized using the [expected Simple Form configuration options](https://www.rubydoc.info/github/plataformatec/simple_form/SimpleForm%2FFormBuilder:error_notification).

## Tailwind workarounds

When using spacing classes such as `space-y-<number>`, Tailwind 2 has [an unfortunate shortcoming](https://github.com/tailwindlabs/tailwindcss/issues/3413) where certain hidden elements disrupt element spacing. Rails's authenticity token unfortunately is one such hidden element that triggers this behavior.

To work around the issue, instead of using spacing classes directly on the `<form>` like this:

```erb
<%= simple_form_for(@foo, builder: SimpleForm::Tailwind::FormBuilder, html: { class: "space-y-6" }) do |f| %>
  <%= f.error_notification %>
  <%= f.input :name %>
<% end %>
```

Instead add a wrapper `<div>` around the form elements:

```erb
<%= simple_form_for(@foo, builder: SimpleForm::Tailwind::FormBuilder) do |f| %>
  <div class="space-y-6">
    <%= f.error_notification %>
    <%= f.input :name %>
  </div>
<% end %>
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

[Simple Form]: https://github.com/heartcombo/simple_form
