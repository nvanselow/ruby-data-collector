require_relative "./lib/session"
require 'pry'

class DataCollector
  def get_session_info
    print "How many minutes is this session?\n> "
    session_duration = gets.chomp.to_i

    @session = Session.new(session_duration)
  end

  def get_behavior
    print "What is the name of this behavior?\n> "
    behavior_name = gets.chomp

    print "Which key on the keyboard will represent this behavior?\n> "
    behavior_key = gets.chomp

    print "What is the description of this behavior?\n> "
    behavior_description = gets.chomp

    behavior = Behavior.new(behavior_name, behavior_key, behavior_description)
    @session.add_behavior(behavior)

    print_current_behaviors

    print "Would you like to add another behavior? (Y/n)> "
    response = gets.chomp.downcase

    if(response == "y" || response == "yes")
      get_behavior
    end
  end

  def start_session
    print "Type any key and <enter> to begin.\n> "
    input = gets.chomp
    puts @session.start
  end

  def run_session
    while @session.running do
      print "Enter behavior key:  "
      input = gets.chomp.downcase

      puts @session.track(input)
    end
  end

  private

  def horizontal_rule
    hr_string = ""
    55.times { hr_string << "-" }
    hr_string << "\n"
  end

  def print_current_behaviors
    current_behaviors = "Current Behaviors:\n"
    current_behaviors << horizontal_rule

    current_behaviors << sprintf("%-20s | ", "Name")
    current_behaviors << sprintf("%-5s | ", "Key")
    current_behaviors << sprintf("%-30s\n", "Description")

    @session.behaviors.each do |behavior|
      current_behaviors << sprintf("%-20s | %-5s | %-30s\n", behavior.name, behavior.key, behavior.description)
    end

    current_behaviors << horizontal_rule

    puts current_behaviors
  end

end
