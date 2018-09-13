require 'rails_helper'

RSpec.describe User, type: :model do
  it "is valid with an email, and password" do
    user = FactoryBot.build(:user)
    user.valid?
    expect(user.errors).to be_empty
  end
  it "is invalid without an email address" do
    user = FactoryBot.build(:user, email: nil)
    user.valid?
    expect(user.errors[:email]).to include("can't be blank")
  end
  it "is invalid with a duplicate email address" do
    FactoryBot.create(:user, email: "john@example.com")
    user = FactoryBot.build(:user, email: "john@example.com")
    user.valid?
    expect(user.errors[:email]).to include("has already been taken")
  end
  it "is invalid with an invalid email address value" do
    user = FactoryBot.build(:user, email: "invalidEmailValue")
    user.valid?
    expect(user.errors[:email]).to include("is invalid")
  end
  it "returns a user's name as a string" do
    name = "johnny"
    email = "#{name}@example.com"
    
    user = FactoryBot.build(:user, email: email)
    expect(user.name).to eq name
  end
end
