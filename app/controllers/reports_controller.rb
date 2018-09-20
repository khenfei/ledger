class ReportsController < ApplicationController
  before_action :authenticate_user!
  
  def index
  end

  def monthly_data
    json_response = { data: [], last_updated: Time.now }
    last_updated = ExpensesMonthlyReport.pluck(:last_updated).first
    
    if last_updated.nil? || last_updated < 30.minute.ago
      ExpensesMonthlyReport.refresh
    end
    
    @expMonthlyReport =  ExpensesMonthlyReport.last_6_month_for_user(current_user.id)
    json_response[:last_updated] = @expMonthlyReport[0].last_updated unless @expMonthlyReport[0].nil?
    json_response[:data] = @expMonthlyReport.reduce([]) { |result, current| 
      result << { month: current.year_month, total: current.total }
    }
    
    respond_to do |format|
      format.json { render json: json_response, status: :ok }
    end
  end

  def category_data
    json_response = { data: {}, last_updated: Time.now }
    Expense.categories.keys.each { |key| json_response[:data].store(key, 0) }

    json_response[:data] = Expense.where(
      user_id: current_user.id, 
      paid_at: Date.today.beginning_of_month..Date.today.at_end_of_month
      ).group(:category).sum(:total)

    respond_to do |format|
      format.json { render json: json_response, status: :ok }
    end
  end
end
