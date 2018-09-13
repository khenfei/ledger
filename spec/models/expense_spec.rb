require 'rails_helper'

RSpec.describe Expense, type: :model do
  let(:expense) { FactoryBot.build(:expense) }
  it "is valid with a category, total, paid_at, user" do
    expect(expense).to be_valid
  end
  it "is invalid without a category" do
    expense.category = nil
    expense.valid?
    expect(expense.errors[:category]).to include("can't be blank")
  end
  it "is invalid with a value not included in category enum" do
    expect {
      expense.category = "invalid"
    }.to raise_error(ArgumentError)
  end
  it "is invalid without a total" do
    expense.total = nil
    expense.valid?
    expect(expense.errors[:total]).to include("can't be blank")
  end
  it "is invalid without a numeric value in total" do
    expense.total = 'invalid'
    expense.valid?
    expect(expense.errors[:total]).to include("is not a number")
  end
  it "is invalid with a negative value in total" do
    expense.total = -10.00
    expense.valid?
    expect(expense.errors[:total]).to include("can't be smaller than 0")
  end
  it "is invalid without a paid_at" do
    expense.paid_at = nil
    expense.valid?
    expect(expense.errors[:paid_at]).to include("can't be blank")
  end

end
