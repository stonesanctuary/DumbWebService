require 'spec_helper'

describe "FriendlyForwardings" do
  it "should forward to the requested page after signin" do
    manager = Factory(:manager)
    visit edit_manager_path(manager)
    
    fill_in :email, :with => manager.email
    fill_in :password, :with => manager.password
    click_button
    
    response.should render_template('managers/edit')
  end
end
