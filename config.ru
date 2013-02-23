
require 'toto'
require 'rack-rewrite'

# Rack config
use Rack::Static, :urls => ['/css', '/js', '/images', '/favicon.ico'], :root => 'public'
use Rack::CommonLogger

if ENV['RACK_ENV'] == 'development'
  use Rack::ShowExceptions
end

#
# Create and configure a toto instance
#
toto = Toto::Server.new do
  #
  # Add your settings here
  # set [:setting], [value]
  # 
    set :author,    'Jason Wells'                             # blog author
    set :title,     'jasonawells.com'                         # site title
  # set :root,      "index"                                   # page to load on /
    set :date,      lambda {|now| now.strftime("%Y/%m/%d") }  # date format for articles
    set :markdown,  :smart                                    # use markdown + smart-mode
  # set :disqus,    false                                     # disqus id, or false
    set :summary,   :max => 1000, :delim => /~/                # length of article summary and delimiter
  # set :ext,       'txt'                                     # file extension for articles
  # set :cache,      28800                                    # cache duration, in seconds
    set :url,       'http://jasonawells.com/'
end

# Redirect www to non-www
if ENV['RACK_ENV'] == 'production'
  use Rack::Rewrite do
    r301 %r{.*}, 'http://jasonawells.com$&', :if => Proc.new {|rack_env|
      rack_env['SERVER_NAME'] != 'jasonawells.com'
    }
  end
end

run toto
