require_relative '../lib/caesar_cipher'

describe Caesar_cipher do
  describe "#translate" do
    it "Works with small positive shift and small word" do
      cipher = Caesar_cipher.new
      expect(cipher.translate('a', 5)).to eq('f')
    end

    it "Works with big positive shift and small word" do
      cipher = Caesar_cipher.new
      expect(cipher.translate('a', 50)).to eq('y')
    end

    it "Works with small positive shift and big word" do
      cipher = Caesar_cipher.new
      expect(cipher.translate("What a string!", 5)).to eq('Bmfy f xywnsl!')
    end
  end
end