#!/usr/bin/env ruby

require 'sinatra/base'
require 'rack/csrf'
require 'sinatra_warden'

require_relative 'lib/sgui.rb'

class Application < Sinatra::Base
  register Sinatra::Warden
  set :auth_template_renderer, 'erb'
  set :auth_success_path, '/groups'
  set :auth_failure_path, '/login'
  
  use Rack::Csrf, :raise => true

  def initialize(app = nil)
    super(app)
    @facade = SguiFacade.new('config/sgui.yml')
  end

  def authenticate
    username = params['username']
    password = params['password']

    if @facade.login(username, password)
      session['username'] = username
    end
  end

  def logout
    session['username'] = nil
  end

  def authenticated?
    !session['username'].nil?
  end

  #############

  before do
    pass if request.path_info =~ %r{/(login|logout)/?}
    authorize!
  end

  get '/' do
    redirect to('/groups')
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

  run! if app_file == $0
end
