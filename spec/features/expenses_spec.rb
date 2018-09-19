require 'rails_helper'

RSpec.feature "Expenses", type: :feature do
  scenario "user visit table listing", js: true do
    
    user = FactoryBot.create(:user)
    3.times { FactoryBot.create(:expense, owner: user) }

    visit root_path
    
    find(:css, ".navbar-toggler-icon").click 
    expect(page).to have_content "Log in"
    click_link "Log in"
    expect(page).to have_content "Login"
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Login"
    expect(page).to have_content "Signed in successfully."
    find(:css, ".navbar-toggler-icon").click 
    click_link "Tables"
    expect(page).to have_content "Expense Listing"
    
    
  end
  scenario "user creates a new expense" do
    user = FactoryBot.create(:user)

    visit root_path
    click_link "Log in"
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Login"

    expect {
      expect(page).to have_content "Signed in successfully."
      click_link "Tables"
      expect(page).to have_content "Expense Listing"
      click_link "New Expense"
      fill_in "Total", with: 50
      fill_in "Tags", with: "FeatureTest;"
      click_button "Create Expense"
      expect(page).to have_content "Expense was successfully created."
    }.to change(Expense.owner(user), :count).by(1)
  end
  scenario "user edit an expense"
  scenario "user delete an expense"
  
end
