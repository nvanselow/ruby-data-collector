require 'Concurrent'
require_relative 'behavior'
require_relative 'response'

class Session
  attr_reader :duration_in_min, :behaviors, :responses, :start_time, :end_time

  def initialize(duration_in_min = 5)
    @duration_in_min = duration_in_min
    @behaviors = []
    @responses = []
    @running = false
    @current_seconds = 1
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
    @current_seconds = 0
    @running = true
    @task = Concurrent::TimerTask.new(execution_interval: 1, timeout_interval: duration_in_seconds) do
      @current_seconds += 1
      monitor_session(@current_seconds)
    end
    @task.execute
    "Session Start!"
  end

  def end_session
    @task.shutdown
    @running = false
    @end_time = Time.now
    puts results
    abort
  end

  def running
    @running
  end

  def monitor_session(seconds_elapsed)
    if(seconds_elapsed >= duration_in_seconds)
      end_session
    end
  end

  def track(key)
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
    result_string = "\n\nResults:\n"
    result_string << "Planned Session Duration: #{duration_in_min} min\n"
    result_string << "Actual Session Duration: #{actual_session_duration} min\n"

    headers = %w(Behavior Frequency Rate)

    headers.each { |header| result_string << sprintf("%-20s | ", header) }
    result_string << "\n"
    result_string << horizontal_rule

    behaviors.each do |behavior|
      result_string << sprintf("%-20s | %-20s | %-20s |\n", behavior.name, behavior.frequency, calcuate_rate(behavior))
    end

    result_string
  end

  private

  def calcuate_rate(behavior)
    behavior.frequency / actual_session_duration
  end

  def actual_session_duration
    (@current_seconds / 60.to_f).round(2)
  end

  def horizontal_rule
    hr_string = ""
    68.times { hr_string << "-" }
    hr_string << "\n"
  end
end
