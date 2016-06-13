class Response
  attr_reader :behavior, :session_time, :timestamp

  def initialize(behavior, session_time, timestamp = nil)
    @behavior = behavior
    @session_time = session_time
    @timestamp = timestamp

    if(@timestamp.nil?)
      @timestamp = Time.now
    end
  end
end
