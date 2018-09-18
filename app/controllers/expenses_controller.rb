class ExpensesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_expense, only: [:show, :edit, :update, :destroy]

  def index
  end

  def data
    respond_to do |format|
      format.html
      format.json { render json: ExpenseDatatable.new(params, user: current_user, view_context: view_context) }
    end
  end

  def new
    @expense = Expense.new
  end

  def show
  end

  def edit
  end

  def create
    @expense = Expense.new(expense_params)
    @expense.owner = current_user
    respond_to do |format|
      if @expense.save
        format.html { redirect_to @expense, notice: 'Expense was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    @expense.tags_str = expense_params[:tags_str] if expense_params.has_key? (:tags_str)
    respond_to do |format|
      if @expense.update(expense_params)
        format.html { redirect_to @expense, notice: 'Expense was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @expense.destroy
    respond_to do |format|
      format.html { redirect_to expenses_url, notice: 'Expense was successfully destroyed.' }
    end
  end

  private

  def set_expense
    @expense = Expense.find(params[:id])
    authorize @expense
  end

  def expense_params
    params.require(:expense).permit(:category, :total, :paid_at, :tags_str)
  end
end
