require_relative "data_collector"

# DataCollector.new.show
collector = DataCollector.new
collector.get_session_info
collector.get_behavior
collector.start_session
collector.run_session
