require_relative "../spec_helper"

feature "see the results" do

  let(:plannedDuration) { 300 }
  let(:sessionEndTime) { 100 }
  let(:sessionEndTimeMin) { (100 / 60.to_f).round(2) }
  let(:behavior_name) { "Behavior A" }
  let(:behavior_key) { "m" }
  let(:behavior_description) { "Some description." }
  let(:behavior_frequency) { 3 }
  let(:behavior_rate) { (3 / sessionEndTimeMin).round(2) }

  before do
    fill_out_session_form
  end

  scenario "user views the results" do
    click_button("Start")
    behavior_frequency.times do
      page.execute_script("session.track('#{behavior_key}');")
    end
    page.execute_script("session.currentTime = #{sessionEndTime};")
    click_button("Stop Session")

    expect(page).to have_content("Results")
    expect(page).to have_content("Planned Session Duration: #{plannedDuration}")
    expect(page).to have_content("Actual Session Duration: #{sessionEndTime}")

    expect(page).to have_content(behavior_name)
    expect(page).to have_content(behavior_frequency)
    expect(page).to have_content(behavior_rate)
  end
end
