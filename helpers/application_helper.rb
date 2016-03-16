module ApplicationHelper
  def warden
    request.env['warden']
  end
  def user
    warden.user
  end
  alias_method :current_user, :user
end
