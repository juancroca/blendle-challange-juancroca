class ApplicationRoute < App
  include ApplicationHelper
  before do
    content_type "application/hal+json"
    puts '[Params]'
    p params
    env['warden'].authenticate!(:access_token)
  end
end
