require_relative '../spec_helper'

feature "run the session" do

  let(:sessionDuration) { 300 }
  let(:behavior_name) { "Behavior A" }
  let(:behavior_key) { "m" }
  let(:behavior_description) { "A description for this behavior" }

  before do
    fill_out_session_form
  end

  scenario "user views the session information" do
    expect(page).to have_content("Session Duration: #{sessionDuration}")
    expect(page).to have_content(behavior_name)
    expect(page).to have_content(behavior_key)
    expect(page).to have_content(behavior_description)
  end

  scenario "user clicks on a behavior to track it" do

  end

  scenario "user hits a key to track a behavior" do

  end

  scenario "user quits the session" do

  end

  scenario "the session times out" do

  end

end
