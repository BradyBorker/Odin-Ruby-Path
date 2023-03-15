class Caesar_cipher
  def translate(word, shift)
    indexes = Array.new
    word.downcase.split('').each {|char| char.ord >= 97 && char.ord <= 122 ? indexes.push(char.ord) : indexes.push(char)}

    remainder = shift % 26

    translated_indexes = indexes.map do |char_index|
      if char_index.is_a?(Numeric)
        remainder.times do 
          char_index += 1
          char_index = 97 if char_index > 122
        end
        char_index
      else
        char_index
      end
    end

    return translated_indexes.map {|item| item.is_a?(Numeric) ? item.chr : item}.join.capitalize
  end
end

# a: 97
# z: 122