require_relative '../lib/board_class'

describe Board do
  describe '#check?' do 
    subject(:board) { described_class.new() }
    let(:piece) { double() }
    
    it 'returns true when king is in check' do
      allow(piece).to receive(:get_valid_moves).and_return([[0, 1], [1, 1]])
      allow(piece).to receive(:color).and_return('white')
      board.instance_variable_set(:@black_king_position, [0, 1])
      expect(board.check?(piece)).to be true
    end

    it 'returns false when king is not in check' do
      allow(piece).to receive(:get_valid_moves).and_return([[0, 1], [1, 1]])
      allow(piece).to receive(:color).and_return('white')
      board.instance_variable_set(:@black_king_position, [0, 5])
      expect(board.check?(piece)).to_not be true
    end
  end

  describe '#checkmate?' do
    subject(:board) { described_class.new() }
    let(:piece) { double() }
    let(:king) { double() }
    
    it 'returns true when king is checkmated' do
      allow(piece).to receive(:color).and_return('white')
      allow(king).to receive(:color).and_return('black')
      board.instance_variable_set(:@black_king_position, [0, 0])
      allow(king).to receive(:get_valid_moves).and_return([[0, 1], [1, 0]])
      board.instance_variable_set(:@board, [[king, '', piece], ['', piece, '']])
      allow(piece).to receive(:get_valid_moves).and_return([[0, 1], [1, 0]])
      expect(board.checkmate?(piece)).to be true
    end
  end
end