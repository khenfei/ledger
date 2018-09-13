class AuthenticatedOnlyController < ApplicationController
  def index
    authorize :authenticatedOnly
  end
end
