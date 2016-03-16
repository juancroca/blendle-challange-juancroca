require './app'
use Rack::PostBodyContentTypeParser

use Rack::Session::Cookie, :secret => "7cb0083e-f930-4f60-b968-8cef69a32f11"

use Warden::Manager do |config|
  config.scope_defaults :default, strategies: [:access_token], action: 'sessions/unauthenticated'
  # config.serialize_into_session{|user| user.id }
  # config.serialize_from_session{|id| User.get(id) }
  config.failure_app = self

end

Warden::Manager.before_failure do |env,opts|
    env['REQUEST_METHOD'] = 'POST'
end

Warden::Strategies.add(:access_token) do
  def valid?
    request.env["HTTP_ACCESS_TOKEN"].is_a?(String)
  end

  def authenticate!

    user = User.find_by(access_token: request.env["HTTP_ACCESS_TOKEN"])
    if(user)
      request.env['warden'].set_user(user)
    else
      fail!("Could not log in")
    end
  end
end

use Rack::Static, :urls => ['/hal-browser'], :root => 'public'

map('/items') { run ItemsRoute }
map('/lists') { run ListsRoute }
map('/tags') { run TagsRoute }
map('/sessions') { run SessionsRoute }
map('/') { run LandingRoute }
run Sinatra::Application
