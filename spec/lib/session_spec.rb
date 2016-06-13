require_relative "../spec_helper"

describe Session do
  let(:session_duration) { 5 }
  let(:session) { Session.new(session_duration) }
  let(:behavior) { Behavior.new('behavior', 'key') }

  describe ".new" do
    it "creates a new session" do
      expect(session).to be_a(Session)
    end

    it "accepts a session duration in minutes on creation" do
      expect { Session.new(5) }.not_to raise_error
    end
  end

  describe "#duration_in_min" do
    it "returns the duration of the session" do
      expect(session.duration_in_min).to eq(5)
    end
  end

  describe "#add_behavior" do
    it "adds a behavior to the session" do
      session.add_behavior(behavior)

      expect(session.behaviors.size).to eq(1)
      expect(session.behaviors[0]).to eq(behavior)
    end
  end

  describe "#remove_behavior" do
    it "removes a behavior when a behavior object is provided" do
      session.add_behavior(Behavior.new('distractor', 'm'))
      session.add_behavior(behavior)
      session.add_behavior(Behavior.new('distractor 2', 'k'))
      session.add_behavior(Behavior.new('distractor 3', 'i'))

      session.remove_behavior(behavior)

      expect(session.behaviors).not_to include(behavior)
      expect(session.behaviors.size).to eq(3)
    end
  end

  describe "#start" do
    it "sets the start time" do
      allow(Time).to receive(:now).and_return('current time', Time.now)
      allow(Timeloop).to receive(:every)

      session.start

      expect(session.start_time).to eq('current time')
    end

    it "starts the session timer" do
      expect(Timeloop).to receive(:every).with(1.seconds, maximum: 300)

      session.start
    end
  end

  describe "#end_session" do
    it "sets the end time" do
      allow(Time).to receive(:now).and_return('current time')

      session.end_session

      expect(session.end_time).to eq('current time')
    end
  end

  describe "#monitor_session" do
    it "calls the #end method when the timer hits the session duration" do
      expect(session).to receive(:end_session)

      session.monitor_session(300)
    end
  end

  describe "#track" do
    before do
      session.add_behavior(behavior)
    end

    it "accepts a key press as an argument" do
      expect { session.track('m') }.not_to raise_error
    end

    it "increases the frequency of a behavior based on key-press" do
      expect(behavior).to receive(:increment).and_return(1)

      session.track(behavior.key)
    end

    it "records the time the behavior was tracked" do
      session.track(behavior.key)

      expect(session.responses.size).to eq(1)

    end

    it "returns a message stating there is no behavior if an unknown letter is provided" do
      bad_key = "zzz"
      expect(session.track(bad_key)).to include("behavior does not exist")
    end

    it "calls the #end method when the key is 'q'" do
      expect(session).to receive(:end_session)

      session.track('q')
    end

    it "calls the #end method when the key is 'quit'" do
      expect(session).to receive(:end_session)

      session.track('quit')
    end

    it "calls end even if uppercase letters are used" do
      expect(session).to receive(:end_session)

      session.track('Q')
    end
  end

  describe "#results" do
    let(:behavior_frequency) { 3 }
    let(:behavior_rate) { 3 / session.duration_in_min.to_f }

    let(:behavior2) { Behavior.new("new behavior", "key 2") }
    let(:behavior2_frequency) { 1 }
    let(:behavior2_rate) { 1 / session.duration_in_min.to_f }

    before do
      session.add_behavior(behavior)
      session.add_behavior(behavior2)

      session.track(behavior.key)
      session.track(behavior2.key)
      session.track(behavior.key)
      session.track(behavior.key)
    end

    it "returns a string that includes the session duration" do
      expect(session.results).to include("Duration: #{session.duration_in_min}")
    end

    it "returns a string that includes a list of each behavior" do
      expect(session.results).to include(behavior.name)
      expect(session.results).to include(behavior2.name)
    end

    it "returns a string that includes the frequency of each behavior" do
      expect(session.results).to include("#{behavior_frequency}")
      expect(session.results).to include("#{behavior2_frequency}")
    end

    it "returns a string that includes the rate of each behavior" do
      expect(session.results).to include("#{behavior_rate}")
      expect(session.results).to include("#{behavior2_rate}")
    end
  end
end
