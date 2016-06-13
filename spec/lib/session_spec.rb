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
    it "starts the session timer" do
      expect(Timeloop).to receive(:every).with(1.seconds, maximum: 300)

      session.start
    end
  end

  describe "#end" do
    it "returns the results" do

    end
  end

  describe "#monitor_session" do
    it "it calls the #end method when the timer hits the session duration" do
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

    end

    it "returns a message stating there is no behavior if an unknown letter is provided" do
      bad_key = "zzz"
      expect(session.track(bad_key)).to include("behavior does not exist")
    end
  end
end
