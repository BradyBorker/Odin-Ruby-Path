dictionary = ["below","down","go","going","horn","how","howdy","it","i","low","own","part","partner","sit"]

def substrings(sentence, dictionary)
  match_count = Hash.new(0)
  for string in sentence.split()
    for word in dictionary
      if string.include?(word) then
        match_count[word] += 1
      end
    end
  end
  puts match_count
end

 substrings("Howdy partner, sit down! How's it going?", dictionary)