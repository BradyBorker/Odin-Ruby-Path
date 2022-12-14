# My attempt

def roman_to_integer(roman_numeral, roman_mapping)
  if roman_numeral.nil? || roman_numeral.length <= 0
    return 0
  end
  for key in roman_mapping.keys
    if key == roman_numeral[0..1]
      return roman_mapping[key] += roman_to_integer(roman_numeral[2..], roman_mapping)
    elsif key == roman_numeral[0]
      return roman_mapping[key] += roman_to_integer(roman_numeral[1..], roman_mapping)
    end
  end
end

roman_mapping = {
  "M" => 1000,
  "CM" => 900,
  "D" => 500,
  "CD" => 400,
  "C" => 100,
  "XC" => 90,
  "L" => 50,
  "XL" => 40,
  "X" => 10,
  "IX" => 9,
  "V" => 5,
  "IV" => 4,
  "I" => 1
}

puts roman_to_integer("DCCLXXXIV", roman_mapping) # => 784

# Answer

def roman_to_integer(roman_mapping, str, result = 0)
  return result if str.empty?
  roman_mapping.keys.each do |roman|
    if str.start_with?(roman)
      result += roman_mapping[roman]
      str = str.slice(roman.length, str.length)
      return roman_to_integer(roman_mapping, str, result)
    end
  end
end
      
