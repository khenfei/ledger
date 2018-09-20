class CreateExpensesMonthlyReport < ActiveRecord::Migration[5.2]
  def up
    execute <<-SQL
      CREATE MATERIALIZED VIEW expenses_monthly_report AS 
      SELECT user_id, COALESCE(sum(total), 0) AS total, (DATE_TRUNC('MONTH', paid_at))::date AS year_month, CURRENT_TIMESTAMP AS last_updated
      FROM expenses
      GROUP BY user_id, (DATE_TRUNC('MONTH', paid_at))::date;

      CREATE UNIQUE INDEX expenses_monthly_report_idx ON expenses_monthly_report(user_id, year_month);
    SQL
  end
  def down
    execute <<-SQL
        DROP INDEX CONCURRENTLY IF EXISTS expenses_monthly_report_idx;

        DROP MATERIALIZED VIEW expenses_monthly_report;
    SQL
    end
end

