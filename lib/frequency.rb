# Module Frequency
# A small dsl written in ruby to work with frequency events (never, sometimes, always..)
#
module Frequency
  NORMALLY  = 0.75
  SOMETIMES = 0.50
  RARELY    = 0.25
  
  # always do something
  # example:
  #   always { puts "ok"}
  def always(cond={})
    yield if block_given?
  end
  
  # normally (75%) do something,
  # see sometimes method
  # example:
  #   normally { puts "ok"}
  def normally(cond={})
    execute_with_probability(cond,NORMALLY ) { yield } if block_given?
  end
  
  # sometimes (50%) do something
  # example:
  #   sometimes do
  #      # some code
  #   end
  # or adjusting the probability
  #   sometimes :with_probability => 0.12 do
  #     # some code
  #   end
  # you can use "12%" instead 0.12
  #   sometimes(:with_probability => '13.6%') { ... }
  def sometimes(cond={})
    execute_with_probability(cond,SOMETIMES) { yield } if block_given?
  end
  
  # rarely (25%) do something,
  # see sometimes method
  # example:
  #   rarely { puts "ok"}
  def rarely(cond={})
    execute_with_probability(cond,RARELY   ) { yield } if block_given?
  end
  
  # never do something
  # example:
  #   never { puts "ok"}  
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
