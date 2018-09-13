require 'rails_helper'

RSpec.describe AuthenticatedOnlyController, type: :controller do

  before do
    @user = FactoryBot.create(:user)
  end

  describe "#index" do
    context "as an authenticated user" do
      it "returns http success" do
        sign_in @user
        get :index
        aggregate_failures do
          expect(response).to be_successful
          expect(response).to have_http_status "200"
        end
      end
    end
    context "as a guess" do
      it "redirects to sign in page" do
        get :index
        aggregate_failures do
          expect(response).to have_http_status "302"
          expect(response).to redirect_to new_user_session_path
        end
      end
    end
  end

end


