class Recipe
  attr_reader :name, :description, :prep_time, :difficulty

  def initialize(name, description, prep_time, difficulty, done = false)
    @name = name
    @description = description
    @prep_time = prep_time
    @difficulty = difficulty
    @done = done
  end

  def done?
    @done
  end

  def mark_done
    @done = true
  end

  def to_s
    "#{@name}\t|| #{@description}"
  end
end
