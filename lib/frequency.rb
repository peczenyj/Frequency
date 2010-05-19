module Frequency
  NORMALLY  = 0.75
  SOMETIMES = 0.50
  RARELY    = 0.25
  
  def self.always(cond={})
    yield if block_given?
  end
  
  def self.normally(cond={})
    self.execute_with_probability(cond,NORMALLY ) { yield } if block_given?
  end
  
  def self.sometimes(cond={})
    self.execute_with_probability(cond,SOMETIMES) { yield } if block_given?
  end
  
  def self.rarely(cond={})
    self.execute_with_probability(cond,RARELY   ) { yield } if block_given?
  end
  
  def self.never(cond={})
    nil
  end
  
  private
  def self.execute_with_probability(conditions,default)
    rate   = conditions[:with_probability] || default
    yield if rand < rate
  end
end
