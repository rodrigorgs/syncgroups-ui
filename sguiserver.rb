#!/usr/bin/env ruby

require 'sinatra'
require 'rack/protection'
#use Rack::Protection

# TODO: how to secure a Sinatra application?:
#
# * http://blog.fil.vasilak.is/blog/2014/02/08/securing-sinatra-micro-framework/
# * see gem `rack_csrf`.
# * http://stackoverflow.com/questions/11337630/preventing-session-fixation-in-ruby-sinatra
# * see gem: https://github.com/rkh/rack-protection

get '/' do
  erb :index
end

get '/groups' do
  erb :groups_index
end

get '/groups/:group' do
  erb :groups_edit
end

post '/groups/:group' do
  erb :groups_show
end