require_relative '../spec_helper'

feature "create a session" do

  scenario "user does not enter session duration" do
    visit '/'

    click_button("Start Session")

    expect(page).to have_content("Please enter a session duration")
  end

  scenario "user does not create any behaviors" do
    visit '/'

    fill_in('session-duration', with: '5')

    click_button("Start Session")

    expect(page).to have_content("Please enter at least one behavior")
  end

end
