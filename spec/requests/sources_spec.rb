require 'spec_helper'

describe "Sources" do
  before { 
    @user = create(:user) 
  }

  it "should allow a user to login & define data sources", js: true do
    visit root_path
    fill_in :email, with: @user.email
    fill_in :password, with: 'foobar'
    click_button 'Login'
    page.should have_content "successful"

    click_link "here"
    fill_in 'Set name', with: "Sales Data"

    click_on "Add Field"

    fill_in 'Field Name', with: "Employee Code"
    select 'Word'

    click_button 'Create'

    page.should have_content "saved"
    click_on 'Show'
    click_on 'View Form'
    page.should have_content 'code'

    fill_in 'Employee code', with: 'FTL01234'
    click_on 'Create'
    page.should have_content 'saved'
  end
end
