# Rspec macros for Testing
# This file is loaded automatically
module ControllerMacros

  # Login user to test controllers
  # create user and sign in user
  def login_user
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      user = FactoryBot.create(:user)
      user.confirm
      sign_in user
    end
  end

end
