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

  describe '#checkmate_or_draw?' do
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

  describe '#escape_check?' do
    context 'King is in check and can escape' do
      subject (:board) { described_class.new }
      let(:piece) { double() }
      let(:king) { double() }

      it 'returns true' do
        allow(piece).to receive(:color).and_return('white')
        allow(piece).to receive(:get_valid_moves).and_return([[0,0], [2,0]])
        allow(king).to receive(:get_valid_moves).and_return([[0,1]])
        allow(king).to receive(:color).and_return('black')
        allow(king).to receive(:forced_move=).with([0, 1])
        board.instance_variable_set(:@board, [[king,'',''],[piece, '', ''], ['','','']])
        board.instance_variable_set(:@black_king_position, [0, 0])
        expect(board.escape_check?(piece)).to eq true
      end
    end

    context 'King is in check and cannot escape' do
      subject(:board) { described_class.new }
      let(:piece1) { double() }
      let(:piece2) { double() }
      let(:king) { double() }
  
      it 'returns false' do
        allow(piece1).to receive(:color).and_return('white')
        allow(piece1).to receive(:get_valid_moves).and_return([[0,0], [2,0]])
        allow(piece2).to receive(:color).and_return('white')
        allow(piece2).to receive(:get_valid_moves).and_return([[0,1]])
        allow(king).to receive(:get_valid_moves).and_return([[0,1]])
        allow(king).to receive(:color).and_return('black')
        allow(king).to receive(:forced_move=).with([])
        board.instance_variable_set(:@board, [[king,'',''],[piece1, '', ''], ['','',piece2]])
        board.instance_variable_set(:@black_king_position, [0, 0])
        expect(board.escape_check?(piece1)).to eq false
      end
    end
  end

  describe '#defeat_check?' do

  end
end