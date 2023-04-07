require_relative '../lib/board_class'

describe Board do
  describe '#check?' do 
    subject(:board) { described_class.new() }
    let(:piece) { double() }
    
    it 'returns true when king is in check' do
      allow(piece).to receive(:get_valid_moves).and_return([[2,1], [1,1], [0,1]])
      allow(piece).to receive(:color).and_return('white')
      allow(piece).to receive(:position).and_return([3,1])
      board.instance_variable_set(:@black_king_position, [0, 1])
      expect(board.check?(piece)).to be true
    end

    it 'returns false when king is not in check' do
      allow(piece).to receive(:get_valid_moves).and_return([[0, 1], [1, 1]])
      allow(piece).to receive(:color).and_return('white')
      allow(piece).to receive(:position).and_return([3,1])
      allow(piece).to receive(:class).and_return(Bishop)
      board.instance_variable_set(:@black_king_position, [0, 5])
      expect(board.check?(piece)).to_not be true
    end

    it 'returns true but path is empty because piece is a pawn' do
      allow(piece).to receive(:get_valid_moves).and_return([[0, 0], [0, 1]])
      allow(piece).to receive(:color).and_return('white')
      allow(piece).to receive(:position).and_return([3,1])
      allow(piece).to receive(:class).and_return(Pawn)
      board.instance_variable_set(:@black_king_position, [0, 1])
      expect(board.check?(piece)).to be true
    end
  end

  describe '#checkmate?' do
    subject(:board) { described_class.new() }
    let(:piece) { double() }
    let(:king) { double() }
    
    xit 'returns true when king is checkmated' do
      allow(piece).to receive(:color).and_return('white')
      allow(king).to receive(:color).and_return('black')
      board.instance_variable_set(:@black_king_position, [0, 0])
      allow(king).to receive(:get_valid_moves).and_return([[0, 1], [1, 0]])
      board.instance_variable_set(:@board, [[king, '', piece], ['', piece, '']])
      allow(piece).to receive(:get_valid_moves).and_return([[0, 1], [1, 0]])
      expect(board.checkmate?(piece)).to be true
    end
  end

  describe '#surrounded_by_allies' do
    subject(:board) { described_class.new() }
    let(:piece) { double() }

    it 'returns true when surrounded by allies' do
      allow(piece).to receive(:color).and_return('white')
      expect(board.surrounded_by_allies(piece)).to be true
    end
  end
end