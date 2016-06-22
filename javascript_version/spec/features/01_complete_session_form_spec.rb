require_relative '../spec_helper'

feature "create a session" do

  scenario "user does not enter session duration" do
    visit '/'

    click_button("Start Session")

    expect(page).to have_content("Please enter a session duration")
    save_screenshot('screenshot.png')
  end

end
