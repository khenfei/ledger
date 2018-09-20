class ExpensesMonthlyReport < ApplicationRecord
  self.table_name = 'expenses_monthly_report'

  scope :last_6_month_for_user, -> (user_id) {
    where(user_id: user_id, year_month: 6.month.ago..Date.today)
  }

  def readonly?
    true
  end

  def self.refresh
    ActiveRecord::Base.connection.execute('REFRESH MATERIALIZED VIEW expenses_monthly_report')
  end
end