class Picker
  def initialize(word)
    @chosen_word = word 
  end

  def self.pick_word(word_list)
    word_list = word_list.split().select {|word| word.length > 5 && word.length < 12}
    self.new(word_list.sample)
  end
end

def main(word_list)
  picker = Picker.pick_word(word_list)
  p picker
end

main(File.read('google-10000-english-no-swears.txt'))
