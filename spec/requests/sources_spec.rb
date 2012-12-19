require 'spec_helper'

describe "Sources" do
  before { 
    @user =  Fabricate(:user, user_with_attr: true)
  }

  it "should allow a user to login & define data sources" do
    visit root_path
    fill_in 'Email', with: @user.email
    fill_in 'Password', with: 'foobar'
    click_button 'Login'
    page.should have_content "successful"

    attr = @user.sources.last.model_attributes.last 

    within ".table" do
      click_on 'Show'
    end
    click_on 'View Form'
    within ".form-inputs" do
      fill_in attr.field_name.humanize, with: "1234"
    end
    click_on 'Create'
    page.should have_content 'saved'
  end
end
