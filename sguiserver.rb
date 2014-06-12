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
  '<a href="groups">Entrar</a>'
end

get '/groups' do
  '<h1>Groups</h1>

  <ul>
    <li><a href="groups/csi">csi</a></li>
  </ul>
  '
end

get '/groups/:group' do
  <<-EOT
  <h1>Grupo: #{params['group']}</h1>

  <h2>Membros</h2>
  <form action="#{params['group']}" method="POST">
    <ul>
      <li><input name="username[]" type="text" value="fulano" /></li>
      <li><input name="username[]" type="text" value="sicrano" /></li>
    </ul>
    <input type="submit" />
  </form>
  <ul>

  EOT
end

post '/groups/:group' do
  <<-EOT
  Ok! #{params['username'].inspect}
  EOT
end