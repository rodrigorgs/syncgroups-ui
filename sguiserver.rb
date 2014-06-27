#!/usr/bin/env ruby

require 'sinatra/base'
require 'rack/csrf'
require 'sinatra_warden'
require 'yaml'

require_relative 'lib/sgui.rb'

YAML_FILENAME = 'config/sgui.yml'
CONFIG = YAML.load_file(YAML_FILENAME)['web']

class Application < Sinatra::Base
  register Sinatra::Warden
  set :auth_template_renderer, 'erb'
  set :auth_success_path, '/groups'
  set :auth_failure_path, '/login'
  set :port, CONFIG['port']
  set :bind, CONFIG['bind']

  use Rack::Csrf, :raise => true

  def initialize(app = nil)
    super(app)

    if ARGV.length > 0 && ARGV[0] == 'development'
      require_relative 'lib/sgui_fake.rb'
      @facade = SguiFakeFacade.new(nil)
      puts "Running SGUI in development mode"
    else
      @facade = SguiFacade.new(YAML_FILENAME)
      puts "Running SGUI in production mode"
    end
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

  def logged_user
    session['username']
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
    @groups = @facade.list_groups_managed_by_user(logged_user)
    erb :groups_index
  end

  before '/groups/:group' do |group|
    if !@facade.can_access_group(logged_user, group)
      halt 401, erb(:error)
    end
  end

  get '/groups/:group' do |group|
    @members = @facade.list_group_members(group)
    erb :groups_edit
  end

  post '/groups/:group' do |group|
    users = params['username'].select { |x| !x.nil? && x != '' }
    @facade.update_group(group, users)
    erb :groups_show
  end

  run! if app_file == $0
end
