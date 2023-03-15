class Caesar_cipher
  def translate(word, shift)
    indexes = Array.new
    word.downcase.split('').each {|char| char.ord >= 97 && char.ord <= 122 ? indexes.push(char.ord) : indexes.push(char)}

    remainder = shift % 26

    translated_indexes = indexes.map do |char_index|
      next if !char_index.is_a? Numeric

      remainder.times do 
        char_index += 1
        char_index = 97 if char_index > 122
      end
      char_index
    end

    return translated_indexes.map {|ord| ord.chr if ord.is_a?(Numeric)}.join
  end
end

# a: 97
# z: 122