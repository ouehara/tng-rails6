require 'rails_helper'

RSpec.describe HotelsController, type: :controller do
  # This should return the minimal set of attributes required to create a valid
  # Article. As you add validations to Article, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # ArticlesController. Be sure to keep this updated too.
  let(:valid_session) { {} }
   
  describe "GET #search" do
    it "responds successfully with an HTTP 200 status code" do
      get :search, :query => "test"
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end
  end
end
