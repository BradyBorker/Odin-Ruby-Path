require_relative '../lib/caesar_cipher'

describe Caesar_cipher do
  describe "#translate" do
    it "Works with small positive shift and small word" do
      cipher = Caesar_cipher.new
      expect(cipher.translate('Aa', 5)).to eq('Ff')
    end

    it "Works with big positive shift and small word" do
      cipher = Caesar_cipher.new
      expect(cipher.translate('Aa', 50)).to eq('Yy')
    end

    it "Works with small positive shift and big word" do
      cipher = Caesar_cipher.new
      expect(cipher.translate("What a string!", 5)).to eq('Bmfy f xywnsl!')
    end

    it "Works with big positive shift and big word" do
      cipher = Caesar_cipher.new
      expect(cipher.translate("Hello world", 50)).to eq("Fcjjm umpjb")
    end

    it "Works with small negative shift and small word" do
      cipher = Caesar_cipher.new
      expect(cipher.translate('Gg', -5)).to eq('Bb')
    end
  end
end