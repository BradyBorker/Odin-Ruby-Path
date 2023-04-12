require_relative '../lib/board_class'

describe Board do
  describe '#check?' do 
    subject(:board) { described_class.new([]) }
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
    subject(:board) { described_class.new([]) }
    let(:piece) { double() }
    
    it 'returns 1 when king is checkmated' do
      allow(board).to receive(:check?).with(piece).and_return(true)
      allow(board).to receive(:remove_forced_moves).with(piece)
      allow(board).to receive(:surrounded_by_allies).with(piece).and_return(false)
      allow(board).to receive(:defeat_check?).with(piece).and_return(false)
      allow(board).to receive(:set_forced_moves).with(piece)
      allow(board).to receive(:escape_possible?).with(piece).and_return(false)
      allow(board).to receive(:puts)
      allow(piece).to receive(:enemy).and_return('black')
      expect(board.checkmate_or_draw?(piece)).to eq 1
    end

    xit 'returns 2 when draw' do
      allow(board).to receive(:check?).with(piece).and_return(false)
      allow(board).to receive(:remove_forced_moves).with(piece)
      allow(board).to receive(:surrounded_by_allies).with(piece).and_return(false)
      allow(board).to receive(:defeat_check?).with(piece).and_return(false)
      allow(board).to receive(:set_forced_moves).with(piece)
      allow(board).to receive(:escape_possible?).with(piece).and_return(false)
      allow(board).to receive(:puts)
      allow(piece).to receive(:enemy).and_return('black')
      expect(board.checkmate_or_draw?(piece)).to eq 2
    end
  end

  describe '#surrounded_by_allies' do
    subject(:board) { described_class.new([]) }
    let(:piece) { double() }

    it 'returns true when surrounded by allies' do
      allow(piece).to receive(:color).and_return('white')
      expect(board.surrounded_by_allies(piece)).to be true
    end
  end

  describe '#escape_possible?' do
    context 'King is in check and can escape' do
      subject (:board) { described_class.new([]) }
      let(:piece) { double() }
      let(:king) { double() }

      it 'returns true' do
        allow(piece).to receive(:color).and_return('white')
        allow(piece).to receive(:get_valid_moves).and_return([[0,0], [2,0]])
        allow(king).to receive(:get_valid_moves).and_return([[0,1]])
        allow(king).to receive(:color).and_return('black')
        allow(king).to receive(:forced_move=).with([[0, 1]])
        board.instance_variable_set(:@board, [[king,'',''],[piece, '', ''], ['','','']])
        board.instance_variable_set(:@black_king_position, [0, 0])
        expect(board.escape_possible?(piece)).to eq true
      end
    end

    context 'King is in check and cannot escape' do
      subject(:board) { described_class.new([]) }
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
        expect(board.escape_possible?(piece1)).to eq false
      end
    end
  end

  describe '#defeat_check?' do
    context 'King is in check and the check can be defeated' do
      subject (:board) { described_class.new([]) }
      let(:attacker) { double() }
      let(:defender) { double() }

      it 'returns true' do
        allow(attacker).to receive(:color).and_return('white')
        allow(defender).to receive(:color).and_return('black')
        allow(attacker).to receive(:enemy).and_return('black')
        allow(defender).to receive(:enemy).and_return('white')
        allow(attacker).to receive(:get_valid_moves).and_return([[0,1]])
        allow(defender).to receive(:get_valid_moves).and_return([[1,0]])
        allow(defender).to receive(:forced_move=).with([[1,0]])
        board.instance_variable_set(:@board, [[defender,'',''],[attacker, '', ''], ['','','']])
        board.instance_variable_set(:@black_king_position, [0, 1])
        board.instance_variable_set(:@path_to_check, [[1,0], [0,1]])
        allow(defender).to receive(:get_valid_moves).with(board).and_return([[1,0],[2,0]])
        expect(board.defeat_check?(attacker)).to eq true
      end
    end

    context 'King is in check and check cannot be defeated' do 
      subject (:board) { described_class.new([]) }
      let(:attacker) { double() }
      let(:defender) { double() }

      it 'returns false' do
        allow(attacker).to receive(:color).and_return('white')
        allow(defender).to receive(:color).and_return('black')
        allow(attacker).to receive(:enemy).and_return('black')
        allow(defender).to receive(:enemy).and_return('white')
        allow(attacker).to receive(:get_valid_moves).and_return([[0,1]])
        allow(defender).to receive(:get_valid_moves).and_return([[1,1]])
        allow(defender).to receive(:forced_move=).with([])
        board.instance_variable_set(:@board, [[defender,'',''],[attacker, '', ''], ['','','']])
        board.instance_variable_set(:@black_king_position, [0, 1])
        board.instance_variable_set(:@path_to_check, [[1,0], [0,1]])
        allow(defender).to receive(:get_valid_moves).with(board).and_return([[1,0],[2,0]])
        expect(board.defeat_check?(attacker)).to eq false
      end
    end 
  end

  describe '#get_legal_moves' do
    context 'Moving piece will put king in check' do
      subject(:board) { described_class.new([]) }
      let(:king) { double() }
      let(:rook) { double() }
      let(:pawn) { double() }

      it 'returns empty list for valid moves' do
        mock_board = [[king, pawn, '', '', rook], ['','','']]
        board.instance_variable_set(:@board, mock_board)
        board.instance_variable_set(:@white_king_position, [0,0])
        allow(king).to receive(:position).and_return([0,0])
        allow(rook).to receive(:class).and_return(Rook)
        allow(rook).to receive(:color).and_return('black')
        allow(rook).to receive(:get_valid_moves).and_return([[0,3],[0,2],[0,1]], [[0,3],[0,2],[0,1], [0,0]])
        allow(pawn).to receive(:class).and_return(Pawn)
        allow(pawn).to receive(:color).and_return('white')
        allow(pawn).to receive(:get_valid_moves).and_return([[1,1]], [[1,1]])
        allow(pawn).to receive(:enemy).and_return('black')
        allow(pawn).to receive(:position).and_return([0,1])
        expect(board.get_legal_moves(pawn)).to eq []
      end
    end
  end
end
  
