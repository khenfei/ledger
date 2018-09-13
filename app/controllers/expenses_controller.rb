class ExpensesController < ApplicationController
  before_action :authenticate_user!

  def index
    authorize Expense
  end

end
