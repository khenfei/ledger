require 'rails_helper'

RSpec.describe HomeController, type: :controller do

  describe "#index" do
    it "returns http success" do
      get :index
      aggregate_failures {
        expect(response).to be_successful
        expect(response).to have_http_status(:success)
      }
    end
  end

end
