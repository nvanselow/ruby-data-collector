class Behavior
  attr_reader :name, :key, :description, :frequency

  def initialize(name, key, description = nil)
    @name = name
    @key = key
    @description = description
    @frequency = 0
  end

  def increment(num = 1)
    @frequency += num
  end
end
