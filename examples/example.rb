require 'inidol'

previous = {
  person: {
    first_name: "Bob",
    last_name: "Wares",
    age: 50
  }
}.to_ini # convert these data to INI string

puts previous # puts it

puts "\n===="

second = previous.from_ini # convert back to Hash
second[:person][:first_name] = "Tom" # set name of person to Tom
second[:person][:age] = 30 # set age of person to 30
puts second.to_ini # also back convert to INI string, puts it!