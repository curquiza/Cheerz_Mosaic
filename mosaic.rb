require 'json'

file = File.read("cats.json")
data = JSON.parse(file);
#puts data
#puts data.keys
#puts data['cats']
photo = data['cats']
puts photo[0]
puts photo[1]['src']
