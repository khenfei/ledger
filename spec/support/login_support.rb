module LoginSupport
  def sign_in_as(user)
    visit root_path
    find(:css, ".navbar-toggler-icon").click
    expect(page).to have_content "Log in"
    click_link "Log in"
    expect(page).to have_content "Login"
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Login"
    expect(page).to have_content "Signed in successfully."
  end
end

RSpec.configure do |config|
  config.include LoginSupport
end