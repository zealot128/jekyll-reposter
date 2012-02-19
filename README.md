# Repost lib for Jekyll blog


I needed a convenient way to repost stuff in a jekyll blog, which i posted in another blog (corporate blog etc).
So i mungled together this gem, which uses Feedzirra as interface, so can handle both RSS and Atom Feeds.

## Install

add to Gemfile or install with gem install:

```ruby
gem "jekyll-reposter"
```

## Usage

create a ruby file in your blog's root folder, or a subfolder like "tools", "import" etc. Here I use a executable in my root, called ```repost-notes```


```ruby
#!/usr/bin/env ruby
#
require "bundler"
Bundler.setup
require "jekyll-reposter"

reposter = Jekyll::Reposter.new "http://notes.it-jobs-und-stellen.de/notes.atom",
  :tags => "[notes, external]", :pretend => true

reposter.create_if do |entry|
  true
end
```

This will create all blog posts, if not existing yet inside my
```source/_posts/notes.it-jobs-und-stellen.de`` folder.

The ```create_if``` directive decides if a blog posts is created. So if you
want to filter the passed feed, like to only show specific authors posts, then
here you can add any logic. In our case, we post all new items.


After finshed, you can run that script like
```bash
ruby tools/notes.rb
```
any time in your workflow, to add all new posts. Afterwards, check formatting and
add categories if necessary.

## Config

There are some options, you can pass to the Reposter:

```ruby
:tags         => "[notes, external]",   #categories
:dir          => "source/_posts",
:allowed_tags => %w[h2 ul li ol h3 h4 h5 code pre quote blockquote cite hr],
:meta => {   #default markdown meta tags
  "comments" => true,
  "layout" => "post"
},
:pretend => false   # do not create posts, but show the generated output
```

Additionally, there are some replacings to make a better output, you can
customize that with the attribute "reposter.replacings", default are:

```ruby
reposter.replacings = {
  "“"       => '"',
  "”"       => '"',
  "&lt;"    => "<",
  "&gt;"    => ">",
  "</li>"   => "",
  "</ul>"   => "",
  "<ul>"    => "",
  "<pre>"   => "\n\n```ruby\n",
  "</pre>"  => "```\n",
  /\s+<li>/ => "* "
}
```

Also, for SEO reasons, a link to the original post will be added at the end of
each entry with a rel=canonical.


