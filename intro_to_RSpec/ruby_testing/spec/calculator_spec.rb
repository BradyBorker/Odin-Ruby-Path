require './lib/calculator'

describe Calculator do
  describe "#add" do
    it "returns the sum of two numbers" do 
      calculator = Calculator.new
      expect(calculator.add(5,2)).to eql(7)
    end

    it "returns the sum of more than two numbers" do 
      calculator = Calculator.new
      expect(calculator.add(2,5,7)).to eq(14)
    end
  end

  describe "#subtract" do
    it "returns the difference between two or more numbers" do
      calculator = Calculator.new
      expect(calculator.subtract(10,5,2)).to eq(3)
    end
  end

  describe "#multiply" do
    it "returns the product of two or more numbers" do
      calculator = Calculator.new
      expect(calculator.multiply(3,2,2)).to eq(12)
    end
  end

  describe "#subtract" do 
    it "returns the quotient of two or more numbers" do
      calculator = Calculator.new
      expect(calculator.divide(100, 10, 2)).to eq(5)
    end
  end
end