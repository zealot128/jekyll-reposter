# encoding: utf-8

require "active_support"
require 'feedzirra'
require "fileutils"
require "uri"
require "stringex"
require "sanitize"
require "yaml"

module Jekyll
  class Reposter
    VERSION = "0.0.1"

    attr_accessor :replacings

    # fetching a single feed
    def initialize(feed, options={})
      @options = {
        :tags         => "[notes, external]",
        :dir          => "source/_posts",
        :allowed_tags => %w[h2 ul li ol h3 h4 h5 code pre quote blockquote cite hr],
        :meta => {
          "comments" => true,
          "layout" => "post"
        },
        :pretend => false
       }.merge options

      @replacings = {
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

      @feed = Feedzirra::Feed.fetch_and_parse(feed)
      @uri = URI.parse(feed)
      @dir = File.join @options[:dir], @uri.host
      FileUtils.mkdir_p(@dir)
      puts "Working dir: #{@dir}"
    end

    # creates the blog entry file, if passed block
    # returns true. block is a entry object from
    # feedzirra, like filtering
    def create_if(&block)
      @feed.entries.each do |entry|
        if block.call(entry)
          create_entry(entry)
        end
      end
    end

    def create_entry(entry)
      date = entry.published.strftime("%Y-%m-%d")
      filename = File.join @dir, date + "-" + entry.title.to_url + ".markdown"
      unless File.exists? filename
        content =  Sanitize.clean entry.content, :elements => @options[:allowed_tags]

        @replacings.each do |from,to|
          content.gsub! from, to
        end

        meta = {
          "title" => entry.title,
          "date" => entry.published.strftime("%Y-%m-%d %H:%M"),
        }.merge(@options[:meta])

        tags = @options[:tags]
        file = <<DOC
        #{meta.to_yaml}
categories: #{tags}
---
#{content}

---
<i>Reposted from <a href='#{entry.url}' rel='canonical'>#{@uri.host}</a></i>
DOC

        if !@options[:pretend]
          File.open filename, "w+" do |f|
            puts "Writing #{filename}"
            f.write file
          end
        else
          breakwater = (["="] * 20).join  + "\n"
          puts "#{breakwater}Would create #{filename} with content:\n#{breakwater}#{file}"
        end

      end
    end
  end
end
