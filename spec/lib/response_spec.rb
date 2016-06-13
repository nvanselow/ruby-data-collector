require 'spec_helper'

describe Response do

  let(:behavior) { Behavior.new("Behavior A", "key") }
  let(:current_session_time) { 30 }
  let(:response) { Response.new(behavior, current_session_time) }

  describe ".new" do
    it "returns a response" do
      expect(response).to be_a(Response)
    end

    it "accepts a behavior and a time" do
      expect { Response.new(behavior, current_session_time) }.not_to raise_error
    end

    it "optionally accepts a timestamp" do
      expect { Response.new(behavior, current_session_time, Time.now) }.not_to raise_error

      response = Response.new(behavior, current_session_time, 'custom time')

      expect(response.timestamp).to eq('custom time')
    end

    it "sets the timestamp if none is provided" do
      allow(Time).to receive(:now).and_return('current time')

      expect(response.timestamp).to eq('current time')
    end
  end
end
