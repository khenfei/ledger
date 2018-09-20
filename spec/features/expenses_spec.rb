require 'rails_helper'

RSpec.feature "Expenses", type: :feature do
  include LoginSupport

  let(:user) { FactoryBot.create(:user) }
  let(:expense) { FactoryBot.create(:expense, owner: user) }
  scenario "user visits table listing", js: true do
    FactoryBot.create(:expense, owner: user, category: 'other')
    FactoryBot.create(:expense, owner: user, category: 'apparel')
    FactoryBot.create(:expense, owner: user, category: 'grocery')

    sign_in_as user
    navigate_to_table_listing

    aggregate_failures {
      expect(page).to have_content "Other"
      expect(page).to have_content "Apparel"
      expect(page).to have_content "Grocery"
    }
    
  end

  scenario "user creates a new expense" do
    sign_in_as user
    navigate_to_table_listing
    
    expect {
      click_link "New Expense"
      fill_in "Total", with: 50
      fill_in "Tags", with: "FeatureTest:Create;"
      click_button "Create Expense"
      expect(page).to have_content "Expense was successfully created."
    }.to change(Expense.owner(user), :count).by(1)
  end
    
  scenario "user edits an expense", js: true do
    expense
    sign_in_as user
    navigate_to_table_listing
    
    find(:css, ".fas.fa-edit").click
    expect(page).to have_content "Edit Expense"
    fill_in "Total", with: 100
    click_button "Update Expense"
    
    expect(page).to have_content "Expense was successfully updated."
    expect(expense.reload.total).to eq(100)
  end

  scenario "user deletes an expense", js: true do
    expense
    sign_in_as user
    navigate_to_table_listing

    find(:css, ".fas.fa-trash-alt").click
    expect(page).to have_content "Are you sure?"
    
    expect {
      click_link "Delete"
      expect(page).to have_content "Expense was successfully destroyed."
    }.to change(Expense.owner(user), :count).by(-1)
  end

  def navigate_to_table_listing
    find(:css, ".navbar-toggler-icon").click 
    click_link "Tables"
    expect(page).to have_content "Expense Listing"
  end
  
end
