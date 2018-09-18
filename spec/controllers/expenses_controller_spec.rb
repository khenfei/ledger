require 'rails_helper'

RSpec.describe ExpensesController, type: :controller do
  let(:user) { FactoryBot.create(:user) }

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
    before do
      @expenses_data = FactoryBot.attributes_for(:expenses_data) 
      @expenses_data[:format] = 'json'
    end

    context "as an authenticated user" do
      it "responds successfully" do
        sign_in user
        post :data, params: @expenses_data.with_indifferent_access
        expect(response).to have_http_status(:success)
      end

      it "returns a JSON response with expected Expenses data" do
        3.times { FactoryBot.create(:expense, owner: user) }
        sign_in user
        post :data, params: @expenses_data.with_indifferent_access
        hash_body = nil
        aggregate_failures "verifying response" do
          expect { 
            hash_body = JSON.parse(response.body).with_indifferent_access 
          }.not_to raise_exception
          expect(hash_body.keys).to match_array(["recordsTotal", "recordsFiltered", "data"])
          expect(hash_body[:recordsTotal]).to eq(3)
        end
      end
    end

    context "as a guest" do
      it "redirects to sign_in page" do
        post :data, params: @expenses_data.with_indifferent_access
        expect(response).to have_http_status "302"
        expect(response).to redirect_to new_user_session_path
      end
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
    let(:expense) { FactoryBot.create(:expense, owner: user )}

    context "as an authenticated user" do
      it "responds successfully" do
        sign_in user
        get :show, params: { id: expense.id }
        expect(response).to have_http_status(:success)
      end
    end

    context "as an unauthorized user" do
      it "redirects to root page" do
        other_user = FactoryBot.create(:user)
        sign_in other_user
        get :show, params: { id: expense.id }
        expect(response).to have_http_status "302"
        expect(response).to redirect_to root_path
      end
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
    let(:expense) { FactoryBot.create(:expense, owner: user )}

    context "as an authenticated user" do
      it "responds successfully" do
        sign_in user
        get :edit, params: { id: expense.id }
        expect(response).to have_http_status(:success)
      end
    end

    context "as an unauthorized user" do
      it "redirects to root page" do
        other_user = FactoryBot.create(:user)
        sign_in other_user
        get :edit, params: { id: expense.id }
        expect(response).to have_http_status "302"
        expect(response).to redirect_to root_path
      end
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
    let(:expense_params) { FactoryBot.attributes_for(:expense) }

    context "as an authenticated user" do
      context "with valid attributes" do
        it "does add an expense" do
          sign_in user
          expect {
            post :create, params: { expense: expense_params }
          }.to change(Expense.owner(user), :count).by(1)
        end
      end

      context "with invalid attributes" do
        it "does not add an expense" do
          expense_params = FactoryBot.attributes_for(:expense, :invalid)
          sign_in user
          expect {
            post :create, params: { expense: expense_params }
          }.to_not change(Expense.owner(user), :count)
        end
      end
    end

    context "as a guest" do
      it "does not add an expense" do
        expect {
          post :create, params: { expense: expense_params }
        }.to_not change(Expense.owner(user), :count)
      end

      it "redirects to sign_in page" do
        post :create, params: { expense: expense_params }
        expect(response).to have_http_status "302"
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "#update" do
    before do
      @expense = FactoryBot.create(:expense, owner: user)
    end

    context "as an authenticated user" do
      context "with valid attributes" do
        it "updates the expense" do
          expense_params = FactoryBot.attributes_for(:expense, total: 100)
          sign_in user
          post :update, params: { id: @expense.id, expense: expense_params }
          expect(@expense.reload.total).to eq (100)
        end
      end

      context "with invalid attributes" do
        it "does not update the expense" do
          expense_params = FactoryBot.attributes_for(:expense, total: -1)
          sign_in user
          post :update, params: { id: @expense.id, expense: expense_params }
          expect(@expense.reload.total).to_not eq (-1)
        end
      end
    end

    context "as an unauthorized user" do
      let(:other_user) { FactoryBot.create(:user) }

      it "does not update the expense" do
        expense_params = FactoryBot.attributes_for(:expense, total: 100)
        sign_in other_user
        post :update, params: { id: @expense.id, expense: expense_params }
        expect(@expense.reload.total).to_not eq (100)
      end

      it "redirects to root page with error message" do
        expense_params = FactoryBot.attributes_for(:expense, total: 100)
        sign_in other_user
        post :update, params: { id: @expense.id, expense: expense_params }
        expect(response).to have_http_status "302"
        expect(response).to redirect_to root_path
      end
    end

    context "as a guest" do
      it "does not update the expense" do
        expense_params = FactoryBot.attributes_for(:expense, total: 100)
        post :update, params: { id: @expense.id, expense: expense_params }
        expect(@expense.reload.total).to_not eq (100)
      end

      it "redirects to sign_in page" do
        expense_params = FactoryBot.attributes_for(:expense, total: 100)
        post :update, params: { id: @expense.id, expense: expense_params }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "#destroy" do
    before do
      @expense = FactoryBot.create(:expense, owner: user)
    end

    context "as an authenticated user" do
      it "deletes the expense" do
        sign_in user
        expect {
          delete :destroy, params: { id: @expense.id }
        }.to change(Expense.owner(user), :count).by(-1)
      end
    end

    context "as an unauthorized user" do
      it "does not delete the expense" do
        expect {
          delete :destroy, params: { id: @expense.id }
        }.to_not change(Expense, :count)
      end
    end

    context "as a guest" do
      it "does not delete the expense" do
        expect {
          delete :destroy, params: { id: @expense.id }
        }.to_not change(Expense, :count)
      end

      it "redirects to sign_in page" do
        delete :destroy, params: { id: @expense.id }
        expect(response).to have_http_status "302"
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
