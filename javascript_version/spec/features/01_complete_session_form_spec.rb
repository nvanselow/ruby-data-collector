require_relative '../spec_helper'

feature "create a session" do

  let(:behavior_name) { "Behavior A" }
  let(:behavior_key) { "M" }
  let(:behavior_description) { "Some description for this behavior." }

  scenario "user can see new session form when first visiting the page" do
    visit '/'

    expect(page).to have_css('#new-session')
  end

  scenario "user cannot see running session page when first visiting page" do
    visit '/'

    expect(page).not_to have_css("#run-session")
  end

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

  scenario "user adds a behavior" do
    visit '/'

    add_behavior

    within('.behaviors') do
      expect(page).to have_content(behavior_name)
      expect(page).to have_content(behavior_key)
      expect(page).to have_content(behavior_description)
    end
  end

  scenario "user completes the new session form" do
    visit "/"

    fill_in('session-duration', with: '5')
    add_behavior

    click_button("Start Session")

    expect(page).to have_content("Click 'Start' to begin session")
    expect(page).not_to have_css('#new-session')
  end

end
