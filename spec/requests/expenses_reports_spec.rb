require 'rails_helper'

RSpec.describe "ExpensesReports", type: :request do
  let(:user) { FactoryBot.create(:user) }
  describe "GET /expenses/reports" do
    context "as an authenticated user" do
      it "responds successfully" do
        sign_in user
        get expenses_reports_path
        expect(response).to have_http_status(200)
      end
    end
    
    context "as a guest" do
      it "redirects to sign_in page" do
        expect_unauthenticated_redirection_of expenses_reports_path
      end
    end
  end

  describe "GET /expenses/reports/monthly_data" do
    context "as an authenticated user" do
      context "with records" do
        it "returns valid monthly data" do 
          3.times { FactoryBot.create(:expense, owner: user) }
          sign_in user
          expect(response_json(reports_monthly_data_path)).to match_array(["data", "last_updated"])
        end
      end
    end

    context "as a guest" do
      it "redirects to sign_in page" do
        expect_unauthenticated_redirection_of reports_monthly_data_path
      end
    end
  end

  describe "GET /expenses/reports/category_data" do
    context "as an authenticated user" do
      context "with records" do
        it "returns valid category data" do
          3.times { FactoryBot.create(:expense, owner: user) }
          sign_in user
          expect(response_json(reports_category_data_path)).to match_array(["data", "last_updated"])
        end
      end
    end
    
    context "as a guest" do
      it "redirects to sign_in page" do
        expect_unauthenticated_redirection_of reports_category_data_path
      end
    end
  end

  def expect_unauthenticated_redirection_of(path)
    get path
    expect(response).to have_http_status "302"
    expect(response).to redirect_to new_user_session_path
  end

  def response_json(path)
    get path, params: { format: 'json' }
    hash_body = {}
    expect { 
      hash_body = JSON.parse(response.body).with_indifferent_access 
    }.not_to raise_exception
    hash_body.keys
  end
  
end
