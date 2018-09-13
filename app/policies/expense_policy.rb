class ExpensePolicy < ApplicationPolicy
  def index?
    user.present?
  end
end