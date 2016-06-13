require 'Timeloop'
require_relative 'behavior'

class Session
  attr_reader :duration_in_min, :behaviors

  def initialize(duration_in_min = 5)
    @duration_in_min = duration_in_min
    @behaviors = []
  end

  def add_behavior(new_behavior)
    @behaviors << new_behavior
  end

  def remove_behavior(behavior)
    @behaviors.delete(behavior)
  end

  def duration_in_seconds
    @duration_in_min * 60
  end

  def start
    Timeloop.every(1.seconds, maximum: duration_in_seconds) do |i|
      monitor_session(i)
    end
  end

  def end_session
  end

  def monitor_session(seconds_elapsed)
    if(seconds_elapsed >= duration_in_seconds)
      end_session
    end
  end

  def track(key)
    behavior = @behaviors.find { |behavior| behavior.key == key }
    if(behavior.nil?)
      "That behavior does not exist. Try again."
    else
      behavior.increment
      "Behavior #{behavior.name} tracked."
    end
  end
end
