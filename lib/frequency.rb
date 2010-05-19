module Frequency
  NORMALLY  = 0.75
  SOMETIMES = 0.50
  RARELY    = 0.25
  
  def always(cond={})
    yield if block_given?
  end
  
  def normally(cond={})
    execute_with_probability(cond,NORMALLY ) { yield } if block_given?
  end
  
  def sometimes(cond={})
    execute_with_probability(cond,SOMETIMES) { yield } if block_given?
  end
  
  def rarely(cond={})
    execute_with_probability(cond,RARELY   ) { yield } if block_given?
  end
  
  def never(cond={})
    nil
  end
  
  private
  def execute_with_probability(conditions,default)
    rate   = conditions[:with_probability] || default
    yield if Kernel.rand() < rate
  end
end
