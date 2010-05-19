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

puts "testes"

x = { :custom => 0, :never => 0, :sometimes => 0, :rarely => 0, :normally => 0, :always =>0 }

Max = 10000
Max.times do |i|
  Frequency.always    { x[:always]   += 1 }
  Frequency.normally  { x[:normally] += 1 }
  Frequency.sometimes { x[:sometimes]+= 1 }
  Frequency.rarely    { x[:rarely]   += 1 } 
  Frequency.never     { x[:never]    += 1 }
  
  Frequency.sometimes :with_probability => 0.12 do
    x[:custom] += 1
  end
end

x.each do |i,j|
  puts "#{i} => #{j*100.0/Max}%"
end

