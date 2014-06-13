#!/usr/bin/env ruby

require 'sinatra'
require 'rack/protection'

require_relative 'lib/sgui.rb'

#use Rack::Protection

# TODO: how to secure a Sinatra application?:
#
# * http://blog.fil.vasilak.is/blog/2014/02/08/securing-sinatra-micro-framework/
# * see gem `rack_csrf`.
# * http://stackoverflow.com/questions/11337630/preventing-session-fixation-in-ruby-sinatra
# * see gem: https://github.com/rkh/rack-protection

enable :sessions

before do
  @facade = SguiFacade.new
end

get '/' do
  erb :index
end

get '/groups' do
  @groups = @facade.list_groups
  erb :groups_index
end

before '/groups/:group' do |group|
  if !@facade.can_access_group(session[:user], group)
    halt 401, erb(:error)
  end
end

get '/groups/:group' do |group|
  @members = @facade.list_group_members(group)
  erb :groups_edit
end

post '/groups/:group' do |group|
  @facade.update_group(group, params['username'])
  erb :groups_show
end