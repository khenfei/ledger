class ExpensePolicy < ApplicationPolicy
 def show?
    own_record?
  end

  def edit?
    own_record?
  end

  def update?
    own_record?
  end

  def destroy?
    own_record?
  end

  private
  
  def own_record?
    user.present? && user == record.owner
  end
end