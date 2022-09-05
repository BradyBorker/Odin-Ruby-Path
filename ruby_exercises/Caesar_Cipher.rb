alphabet = Array.new
('a'..'z').each {|char| alphabet.push(char)}
alphabet = alphabet.reverse

def cipher(alphabet, string, shift=0)
  new_indexes = []
  new_string = []
  
  indexes = string.split('').map {|char| alphabet.find_index(char.downcase).nil? ? char : alphabet.find_index(char.downcase)} 
  indexes.each {|index| !(index.is_a? Numeric) ? new_indexes.push(index) : new_indexes.push(index-shift)}
  new_indexes.each {|index| !(index.is_a? Numeric) ? new_string.push(index) : new_string.push(alphabet[index])}
  
  return new_string.join.capitalize
  
end

puts cipher(alphabet, "What a string!", 5)
