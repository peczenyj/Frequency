
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
