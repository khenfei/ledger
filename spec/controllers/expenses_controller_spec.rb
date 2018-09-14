require 'rails_helper'

RSpec.describe ExpensesController, type: :controller do
  let(:user) { FactoryBot.create(:user) }
  let(:expense) { FactoryBot.create(:expense, owner: user )}
  describe "#index" do
    context "as an authenticated user" do
      it "responds successfully" do
        sign_in user
        get :index
        expect(response).to have_http_status(:success)
      end
    end
    context "as a guest" do
      it "redirects to sign_in page" do
        get :index
        expect(response).to have_http_status "302"
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "#data" do
    context "as an authenticated user" do
      it "responds successfully"
      it "returns a JSON string"
    end
    context "as a guest" do
      it "retuns an empty JSON string"
    end
  end

  describe "#new" do
    context "as an authenticated user" do
      it "responds successfully" do
        sign_in user
        get :new
        expect(response).to have_http_status(:success)
      end
    end
    context "as a guest" do
      it "redirects to sign_in page" do
        get :new
        expect(response).to have_http_status "302"
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "#show" do
    context "as an authenticated user" do
      it "responds successfully" do
        sign_in user
        get :show, params: { id: expense.id }
        expect(response).to have_http_status(:success)
      end
    end
    context "as an unauthorized user" do
      it "redirects to index page"
    end
    context "as a guest" do
      it "redirects to sign_in page" do
        get :show, params: { id: expense.id }
        expect(response).to have_http_status "302"
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "#edit" do
    context "as an authenticated user" do
      it "responds successfully" do
        sign_in user
        get :edit, params: { id: expense.id }
        expect(response).to have_http_status(:success)
      end
    end
    context "as an unauthorized user" do
      it "redirects to index page"
    end
    context "as a guest" do
      it "redirects to sign_in page" do
        get :show, params: { id: expense.id }
        expect(response).to have_http_status "302"
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "#create" do
    context "as an authenticated user" do
      context "with valid attributes" do
        it "does add an expense"
      end
      context "with invalid attributes" do
        it "does not add an expense"
      end
    end
    context "as a guest" do
      it "does not add an expense"
      it "redirects to sign_in page"
    end
  end

  describe "#update" do
    context "as an authenticated user" do
      context "with valid attributes" do
        it "updates the expense"
      end
      context "with invalid attributes" do
        it "does not update the expense"
      end
    end
    context "as an unauthorized user" do
      it "does not update the expense"
      it "redirects to index page with error message"
    end
    context "as a guest" do
      it "does not update the expense"
      it "redirects to sign_in page"
    end
  end

  describe "#destroy" do
    context "as an authenticated user" do
      it "deletes the expense"
    end
    context "as an unauthorized user" do
      it "does not delete the expense"
    end
    context "as a guest" do
      it "does not delete the expense"
      it "redirects to sign_in page"
    end
  end
  
end
