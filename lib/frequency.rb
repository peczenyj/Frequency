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
    rate = conditions[:with_probability] || default
    rate = Float(rate) rescue correct_if_string(rate)
    raise "probability must be [0..100]%" unless 0 <= rate && rate <= 1 
    yield if Kernel.rand() < rate
  end
  
  def correct_if_string(rate)
     Float(rate.gsub(/%$/,""))/100 if rate =~ /^-?\d+(.\d+)?%$/
  end
end
