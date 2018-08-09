class DummyPolicy < ApplicationPolicy
  def index?
    user.present?
  end

  private
  
  def dummy
    record
  end
end