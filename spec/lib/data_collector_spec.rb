require "spec_helper"

describe DataCollector do

  let(:data_collector) { DataCollector.new }

  it "runs the session" do
    allow(data_collector).to receive(:gets)
      .and_return("1", "behavior a", "a", "Some fake description", "n",
        "start", "a", "a", "q")

      expect { data_collector.get_session_info }.not_to raise_error
      expect { data_collector.get_behavior }.not_to raise_error
      expect { data_collector.start_session }.not_to raise_error
      expect { data_collector.run_session }.to raise_error(SystemExit)
  end
end
