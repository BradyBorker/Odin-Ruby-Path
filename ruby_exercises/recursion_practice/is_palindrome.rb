# My attempt

def is_palindrome(string, reversed=[], original=[])
  if string.length <= 0
    return reversed.join('') == original.join('')
  end
  
  reversed.unshift(string[0])
  original.append(string[0])
  is_palindrome(string[1..], reversed, original)
end

puts is_palindrome('racecar')

# Answer

def palindrome(string)
  if string.length <= 0
    true
  else
    if string[0] == string[-1]
      palindrome(string[1..-2])
    else
      false
    end
  end
end

puts palindrome('racecar')