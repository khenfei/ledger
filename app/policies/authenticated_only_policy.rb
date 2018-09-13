class AuthenticatedOnlyPolicy < Struct.new(:user, :authenticatedOnly)

  def index?
    user.present?
  end
end