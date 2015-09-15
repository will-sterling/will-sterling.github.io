  def setup_summary_generator(
    separator = /(READMORE)/i,
    readmore_text = 'Read more',
    link_to_separator_position = true)

    return Proc.new  do |resource, rendered, length, ellipsis|
      require 'middleman-blog/truncate_html'
      if link_to_separator_position
        readmore_link = "\n<p class = 'readmore'>#{link_to(readmore_text, resource, :fragment => 'readmore')}</p>"
      else
        readmore_link = "\n<p class = 'readmore'>#{link_to(readmore_text, resource)}</p>"
      end

      if rendered =~ separator
        # The separator is found in the text
        summary = rendered.split(separator).first
        summary + readmore_link   # return
      elsif length
        summary = TruncateHTML.truncate_html(rendered, length, ellipsis)
        unless summary.strip == rendered.strip  # If the
              # original text was longer then the summary...
          summary = summary + readmore_link     # ...add
              # a read more-link.
        end
        summary    # return
      else
        rendered   # return
      end
    end
  end

###
# Blog settings
###
 @readmore_separator = /(<p>)?\(ReadMore\)(<\/p>)?/i

 Time.zone = "Mountain Time (US & Canada)"

page "/presentations/*", :layout => "preso_layout"
activate :blog do |blog|
  blog.name = "preso"
  blog.prefix = "presentations"
  # This will add a prefix to all links, template references and source paths
  # blog.prefix = "blog"

  # blog.permalink = "{year}/{month}/{day}/{title}.html"
  # Matcher for blog source files
  # blog.sources = "{year}-{month}-{day}-{title}.html"
  # blog.taglink = "tags/{tag}.html"
   blog.layout = "preso_layout"
   blog.summary_separator = /DUMMY Seperator/
   blog.summary_length = 250
   blog.summary_generator = setup_summary_generator(@readmore_separator)
  # blog.year_link = "{year}.html"
  # blog.month_link = "{year}/{month}.html"
  # blog.day_link = "{year}/{month}/{day}.html"
  # blog.default_extension = ".markdown"

  blog.tag_template = "/presentations/tag.html"
  blog.calendar_template = "/presentations/calendar.html"

  # Enable pagination
   blog.paginate = true
   blog.per_page = 10
   blog.page_link = "page/{num}"
end

page "/blog/*", :layout => "blog_layout"
activate :blog do |blog|
  blog.name = "blog"
  blog.prefix = "blog"
  # This will add a prefix to all links, template references and source paths
  # blog.prefix = "blog"

  # blog.permalink = "{year}/{month}/{day}/{title}.html"
  # Matcher for blog source files
  # blog.sources = "{year}-{month}-{day}-{title}.html"
  # blog.taglink = "tags/{tag}.html"
   blog.layout = "blog_layout"
   blog.summary_separator = /DUMMY SPEERATOR/
   blog.summary_length = 250
   blog.summary_generator = setup_summary_generator(@readmore_separator)
  # blog.year_link = "{year}.html"
  # blog.month_link = "{year}/{month}.html"
  # blog.day_link = "{year}/{month}/{day}.html"
  # blog.default_extension = ".markdown"

  blog.tag_template = "/blog/tag.html"
  blog.calendar_template = "/blog/calendar.html"

  # Enable pagination
   blog.paginate = true
   blog.per_page = 10
   blog.page_link = "page/{num}"
end

page "/feed.xml", layout: false

###
# Compass
###

# Change Compass configuration
# compass_config do |config|
#   config.output_style = :compact
# end

###
# Page options, layouts, aliases and proxies
###

# Per-page layout changes:
#
# With no layout
page "/index.html", layout: false
#
# With alternative layout
# page "/path/to/file.html", layout: :otherlayout
#
# A path which all have the same layout
# with_layout :admin do
#   page "/admin/*"
# end

# Proxy pages (http://middlemanapp.com/basics/dynamic-pages/)
# proxy "/this-page-has-no-template.html", "/template-file.html", locals: {
#  which_fake_page: "Rendering a fake page with a local variable" }

###
# Helpers
###

activate :directory_indexes

# Automatic image dimensions on image_tag helper
# activate :automatic_image_sizes

# Reload the browser automatically whenever files change
# activate :livereload

# Methods defined in the helpers block are available in templates
# helpers do
#   def some_helper
#     "Helping"
#   end
# end

set :css_dir, 'stylesheets'

set :js_dir, 'javascripts'

set :images_dir, 'images'

# Build-specific configuration
configure :build do
  # For example, change the Compass output style for deployment
  # activate :minify_css

  # Minify Javascript on build
  # activate :minify_javascript

  # Enable cache buster
  # activate :asset_hash

  # Use relative URLs
   activate :relative_assets

  # Or use a different image path
  # set :http_prefix, "/Content/images/"
end

activate :deploy do |deploy|
  deploy.method = :git
  # Optional Settings
  # deploy.remote   = 'custom-remote' # remote name or git url, default: origin
  deploy.branch   = 'master' # default: gh-pages
  # deploy.strategy = :submodule      # commit strategy: can be :force_push or :submodule, default: :force_push
  # deploy.commit_message = 'custom-message'      # commit message (can be empty), default: Automated commit at `timestamp` by middleman-deploy `version`
end


helpers do
  def cleanup_readmore(html)
    html.sub(@readmore_separator, "<span id='readmore'></span>")
  end
end
