class ExpenseDatatable < ApplicationDatatable

  def_delegators :@view, :expense_path, :edit_expense_path

  def initialize(params, opts = {})
    @view = opts[:view_context]
    super
  end

  def view_columns
    @view_columns ||= {
      category: { source: "Expense.category" },
      total: { source: "Expense.total" },
      paid_at: { source: "Expense.paid_at", searchable: false },
      tags: { source: "Expense.tags" } #,
    }
  end

  def data
    records.map do |record|
      {
        category: record.category,
        total: record.total,
        paid_at: record.paid_at,
        tags: record.tags_str,
        path: "#{expense_path(record)};#{edit_expense_path(record)}"
      }
    end
  end
  
  def get_raw_records
    Expense.where(owner: user)
  end

  def user
    @user ||= options[:user]
  end

end
