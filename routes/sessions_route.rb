require 'sinatra/json'

class SessionsRoute < Sinatra::Base
  include ApplicationHelper

  before do
    content_type "application/hal+json"
    puts '[Params]'
    p params
  end

  post '/unauthenticated' do
    content_type 'application/json'
    status 403
    json({ message: "Sorry, this request can not be authenticated. Try again." })
  end

  post '/sign_up' do
    user_params = params["user"]
    user = User.new(user_params)
    if(user.save)
      HAL::UserRepresenter.new(user).to_json
    else
      status 202
      json({"message": "user not created", "errors": user.errors.messages.to_a})
    end
  end

  put '/sign_in' do
    user_params = params["user"]
    user = User.find_by(email: user_params['email'])
    print user.inspect
    if(user && user.authenticate(user_params['password']))
      user.set_access_token
      HAL::UserRepresenter.new(user).to_json
    else
      status 202
      json({"message": "wrong email or password"})
    end
  end

  delete '/logout' do
    env['warden'].authenticate!(:access_token)
    current_user.destroy_token
    json({message: "user's access token destroyed"})
  end
end
