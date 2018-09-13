class AuthenticatedOnlyController < ApplicationController
  before_action :authenticate_user!

  def index
    authorize :authenticatedOnly
  end
end
