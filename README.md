# SimpleForm::Tailwind

Tailwind components for [Simple Form][]

## Prerequisites

You should have these installed first:

* [Simple Form gem][Simple Form]
* [Tailwind][]
  * We're agnostic about install method; the Rails [tailwindcss-rails gem][] is one method
* [Heroicon gem][]
  * Be sure to [run the install generator][heroicon generator] if it's a new dependency to your project

[Simple Form]: https://github.com/heartcombo/simple_form
[Tailwind]: https://tailwindcss.com/
[tailwindcss-rails gem]: https://github.com/rails/tailwindcss-rails
[Heroicon gem]: https://github.com/bharget/heroicon
[heroicon generator]: https://github.com/bharget/heroicon#installation

## Installation

Add to your application's Gemfile:

```ruby
gem "simple_form_tailwind_css"
```

And then execute:

```
$ bundle install
```

Next, overwrite your Simple Form initializer with ours:

```
$ rails g simple_form:tailwind:install
```

Finally, for Tailwind 3 we need to modify `tailwind.config.js` to add an environment
variable that tells Tailwind where the gem's Ruby source is so that classes used by
the gem aren't pruned by Tailwind's JIT:

```diff
--- a/tailwind.config.js
+++ b/tailwind.config.js
@@ -4,6 +4,7 @@ const colors = require('tailwindcss/colors')
 /** @type {import('tailwindcss').Config} */
 module.exports = {
   content: [
+    `${process.env.SIMPLE_FORM_TAILWIND_DIR}/**/*.rb`,
     './app/views/**/*.{html,erb,haml}',
     './app/helpers/**/*.rb',
     './app/javascript/**/*.{js,jsx,ts,tsx,vue}',
```

We're not done yet - jump down to the
[Tailwind JIT configuration](#tailwind-jit-configuration) section to read
approaches on how to pass in this variable to complete setup.

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

## Tailwind JIT configuration

How to pass the `SIMPLE_FORM_TAILWIND_DIR` environment variable in to
`tailwind.config.js` is going to vary depending on how your build setup calls
the `tailwindcss` CLI.

If you're using the [tailwindcss-rails gem][] with its `tailwindcss:build` and `tailwindcss:watch` rake tasks, you can override them with something like this:

```ruby
# lib/tasks/tailwindcss.rake

TAILWIND_COMPILE_COMMAND = "#{RbConfig.ruby} #{Pathname.new(__dir__).to_s}/../../exe/tailwindcss -i '#{Rails.root.join("app/assets/stylesheets/application.tailwind.css")}' -o '#{Rails.root.join("app/assets/builds/tailwind.css")}' -c '#{Rails.root.join("config/tailwind.config.js")}' --minify"
SIMPLE_FORM_TAILWIND_GEMDIR = `bundle show simple_form_tailwind_css`

Rake::Task["tailwindcss:build"].clear
Rake::Task["tailwindcss:watch"].clear
namespace :tailwindcss do
  desc "Build your Tailwind CSS"
  task :build do
    system({"SIMPLE_FORM_TAILWIND_GEMDIR" => SIMPLE_FORM_TAILWIND_GEMDIR}, TAILWIND_COMPILE_COMMAND, exception: true)
  end

  desc "Watch and build your Tailwind CSS on file changes"
  task :watch do
    system({"SIMPLE_FORM_TAILWIND_GEMDIR" => SIMPLE_FORM_TAILWIND_GEMDIR}, "#{TAILWIND_COMPILE_COMMAND} -w")
  end
end
```

For myself, using [Propshaft][] and an npm script, I made this change:

```diff
--- a/package.json
+++ b/package.json
@@ -50,10 +50,10 @@
   },
   "scripts": {
     "build-dev:js": "esbuild `find app/javascript -type f` --tsconfig=./tsconfig.json --bundle --sourcemap --outdir=app/assets/builds --public-path=assets",
-    "build-dev:tailwind": "tailwindcss -i ./app/assets/stylesheets/application.tailwind.css -o ./app/assets/builds/tailwind.css --minify",
+    "build-dev:tailwind": "SIMPLE_FORM_TAILWIND_DIR=\"`bundle show simple_form_tailwind_css`\" tailwindcss -i ./app/assets/stylesheets/application.tailwind.css -o ./app/assets/builds/tailwind.css --minify",
     "build-dev:css": "sass ./app/assets/stylesheets/application.sass.scss:./app/assets/builds/application.css --no-source-map --load-path=node_modules"
   }
 }
```

[Propshaft]: https://github.com/rails/propshaft

As an absolute last resort, instead of dynamically setting the `content` config
option you could use `safelist` instead. [Here's an example][safelist example]
from the project issues.

However, this approach is [discouraged by Tailwind][], and is unsupported by this
gem as it's likely to break in the future if class names are changed.

[discouraged by Tailwind]: https://tailwindcss.com/docs/content-configuration#safelisting-classes
[safelist example]: https://github.com/abevoelker/simple_form_tailwind_css/issues/4#issuecomment-1232210573

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

