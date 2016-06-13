require 'Timeloop'
require_relative 'behavior'
require_relative 'response'

class Session
  attr_reader :duration_in_min, :behaviors, :responses, :start_time, :end_time

  def initialize(duration_in_min = 5)
    @duration_in_min = duration_in_min
    @behaviors = []
    @responses = []
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
    @start_time = Time.now
    Timeloop.every(1.seconds, maximum: duration_in_seconds) do |i|
      monitor_session(i)
    end
  end

  def end_session
    @end_time = Time.now
    results
  end

  def monitor_session(seconds_elapsed)
    @current_time = seconds_elapsed
    if(seconds_elapsed >= duration_in_seconds)
      end_session
    end
  end

  def track(key, time = 0)
    if(key.downcase == 'q' || key.downcase == 'quit')
      return end_session
    end

    behavior = @behaviors.find { |behavior| behavior.key == key }
    if(behavior.nil?)
      "That behavior does not exist. Try again."
    else
      behavior.increment
      @responses << Response.new(behavior, @current_time)
      "Behavior #{behavior.name} tracked."
    end
  end

  def results
    result_string = "Results:\n"
    result_string << "Session Duration: #{duration_in_min} min\n"

    headers = %w(Behavior Frequency Rate)

    headers.each { |header| result_string << sprintf("%-20s | ", header) }
    result_string << "\n"

    behaviors.each do |behavior|
      result_string << sprintf("%-20s | %-20s | %-20s\n", behavior.name, behavior.frequency, calcuate_rate(behavior))
    end

    result_string
  end

  private

  def calcuate_rate(behavior)
    behavior.frequency / duration_in_min.to_f
  end
end
