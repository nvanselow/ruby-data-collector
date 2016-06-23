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

  scenario "the behavior divs are disabled before start is clicked" do
    expect(page).to have_selector('.disabled-div')
  end

  scenario "user clicks a button to start the session" do
    click_button("Start")

    expect(page).not_to have_selector('.disabled-div')
    expect(page).not_to have_content("Start")
    expect(page).to have_content("End Session")
  end

  scenario "user clicks on a behavior to track it" do
    click_button("Start")

    # had to do this version because it kept producing an overlapping error
    find("#track_#{behavior_key}").trigger('click')
    # click_button("#track_#{behavior_key}")

    within('.behaviors') do
      expect(page).to have_content(1);
    end
  end

  scenario "user hits a key to track a behavior" do
    click_button("Start")

    # This one wasn't working
    # find('body').native.send_key(behavior_key);

    page.execute_script("$('body').trigger({ type: 'keypress', which: 109, key: 'm' });")

    within('.behaviors') do
      expect(page).to have_content(1);
    end
  end

  scenario "user ends the session" do
    click_button("Start")

    click_button("Stop Session")

    expect(page).to have_content('Results')
    expect(page).not_to have_content('Run Session')
  end

  scenario "the session times out" do
    session = page.execute_script("session.currentTime = #{sessionDuration - 1};")

    click_button("Start")

    expect(page).to have_content('Results');
  end

end
