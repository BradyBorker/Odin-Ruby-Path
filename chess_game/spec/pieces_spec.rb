require_relative '../lib/pieces/pawn_class'
require_relative '../lib/pieces/bishop_class'
require_relative '../lib/pieces/knight_class'
require_relative '../lib/pieces/rook_class'
require_relative '../lib/pieces/king_class'

describe Pawn do
  describe '#get_possible_moves' do
    subject(:pawn) { described_class.new([1,1], 'white') }

    it 'returns moves available for white pawn' do
      expect(pawn.get_possible_moves).to eq [[0,1], [0,0], [0,2], [-1,1]]
    end

    it 'returns moves available for black pawn' do
      pawn.instance_variable_set(:@color, 'black')
      expect(pawn.get_possible_moves).to eq [[2,1], [2,0], [2,2], [3,1]]
    end
  end

  describe '#prune_moves' do
    subject(:pawn) { described_class.new([1,1], 'white') }
    let(:enemy) { double() }
    let(:allie) { double() }

    context 'Can move forward and has no enemies to attack' do
      it 'returns one possible move' do
        board_state = [[' ', ' ', ' '], [' ', ' ', ' '], [' ', ' ', ' ']]
        expect(pawn.prune_moves(board_state, [[0,1], [0,0], [0,2]])). to eq [[0,1]]
      end
    end

    context 'Cannot move forward and has no enemies to attack' do
      it 'returns an empty list' do
        allow(enemy).to receive(:color).and_return('black')

        board_state = [[' ', enemy, ' '], [' ', ' ', ' '], [' ', ' ', ' ']]
        expect(pawn.prune_moves(board_state, [[0,1], [0,0], [0,2]])). to eq []      
      end
    end

    context 'Can move forward and has one enemy' do
      it 'returns two possible moves' do
        allow(enemy).to receive(:color).and_return('black')

        board_state = [[enemy, ' ', ' '], [' ', ' ', ' '], [' ', ' ', ' ']]
        expect(pawn.prune_moves(board_state, [[0,1], [0,0], [0,2]])). to eq [[0,1], [0, 0]]     
      end
    end

    context 'Allies are in attack area' do
      it "won't attack allies only return forward movement" do
        allow(enemy).to receive(:color).and_return('black')
        allow(allie).to receive(:color).and_return('white')

        board_state = [[allie, ' ', allie], [' ', ' ', ' '], [' ', ' ', ' ']]
        expect(pawn.prune_moves(board_state, [[0,1], [0,0], [0,2]])).to eq [[0,1]]   
      end
    end

    context 'Has not moved yet' do
      it 'can move two spaces' do
        pawn.instance_variable_set(:@has_moved, false)
        pawn.instance_variable_set(:@position, [2,1])

        board_state = [['', ' ', ''], [' ', ' ', ' '], [' ', ' ', ' ']]
        expect(pawn.prune_moves(board_state, [[1,1], [1,0], [1,2], [0, 1]])).to eq [[1,1],[0,1]]
      end
    end

    context 'Has not moved yet but is being blocked' do
      it 'returns an empty list' do
        pawn.instance_variable_set(:@has_moved, false)
        pawn.instance_variable_set(:@position, [2,1])
        allow(enemy).to receive(:color).and_return(:black)

        board_state = [['', ' ', ''], [' ', enemy, ' '], [' ', ' ', ' ']]
        expect(pawn.prune_moves(board_state, [[1,1], [1,0], [1,2], [0, 1]])).to eq []
      end
    end

    context 'Has not moved yet but enemy is two spaces away' do
      it 'returns one move' do
        pawn.instance_variable_set(:@has_moved, false)
        pawn.instance_variable_set(:@position, [2,1])
        allow(enemy).to receive(:color).and_return(:black)

        board_state = [[' ', enemy, ' '], [' ', ' ', ' '], [' ', ' ', ' ']]
        expect(pawn.prune_moves(board_state, [[1,1], [1,0], [1,2], [0, 1]])).to eq [[1,1]]
      end
    end
  end

  describe '#out_of_bounds?' do
    subject(:pawn) { described_class.new([1,1], 'white') }

    it 'returns true when row is neg out of bounds' do
      expect(pawn.out_of_bounds?([-1,0])).to be true
    end

    it 'returns true when row is pos out of bounds' do
      expect(pawn.out_of_bounds?([8,0])).to be true
    end

    it 'returns true when col is neg out of bounds' do
      expect(pawn.out_of_bounds?([0,-1])).to be true
    end

    it 'returns true when col is pos out of bounds' do
      expect(pawn.out_of_bounds?([0,8])).to be true
    end
  end
end

describe Bishop do
  describe '#up_right' do
    subject(:bishop) { described_class.new([3, 0], 'white') }
    
    it 'returns tiles that are +x +y' do 
      expect(bishop.get_up_right(3, 0)).to eq [[2,1], [1,2], [0, 3]]
    end
  end

  describe '#up_left' do
    subject(:bishop) { described_class.new([3, 3], 'white') }

    it 'returns tiles that are -x +y' do
      expect(bishop.get_up_left(3,3)).to eq [[2,2], [1, 1], [0,0]]
    end
  end

  describe '#down_right' do
    subject(:bishop) { described_class.new([5,0], 'white') }

    it 'returns tile that are +x -y' do
      expect(bishop.get_down_right(5,0)).to eq [[6,1], [7,2]]
    end
  end

  describe '#down_left' do
    subject(:bishop) { described_class.new([5,2], 'white')}

    it 'returns tiles that are -x -y' do
      expect(bishop.get_down_left(5,2)).to eq [[6,1], [7,0]]
    end
  end

  describe '#prune_moves' do
    context 'Bishop in corner one enemy' do
      subject(:bishop) { described_class.new([0,0], 'white')}
      let(:enemy) { double() }

      it 'returns all tiles up to and including enemy tile' do
        allow(enemy).to receive(:color).and_return('black')
        moves = {m: [[1,1], [2,2], [3,3], [4,4], [5,5]]}
        board_state = [[bishop,'',''], ['','',''],['','',enemy]]
        expect(bishop.prune_moves(board_state, moves)).to eq [[1,1],[2,2]]
      end
    end

    context 'Bishop in corner one allie' do
      subject(:bishop) { described_class.new([0,0], 'white')}
      let(:allie) { double() }

      it 'returns all tiles up to allie' do
        allow(allie).to receive(:color).and_return('white')
        moves = {m: [[1,1], [2,2], [3,3], [4,4], [5,5]]}
        board_state = [[bishop,'',''], ['','',''],['','',allie]]
        expect(bishop.prune_moves(board_state, moves)).to eq [[1,1]]
      end
    end
  end
end

describe Knight do
  describe '#get_possible_moves' do
    subject(:knight) { described_class.new([4,4], 'white') }
    it 'returns all possible moves' do
      expect(knight.get_possible_moves).to eq [[5,6], [6,5], [3,6], [2,5], [2,3], [3,2], [5,2], [6,3]]
    end

    it 'does not return out of bound values' do
      knight.instance_variable_set(:@position, [0,0])
      expect(knight.get_possible_moves).to eq [[1,2], [2,1]]
    end
  end

  describe '#prune_moves' do
    subject(:knight) { described_class.new([0,0], 'white')}
    let(:enemy) { double() }
    let(:allie) { double() }

    it 'returns spaces which contain an enemy' do
      allow(enemy).to receive(:color).and_return('black')
      board_state = [[knight,'',''],['','',enemy],['','','']]
      moves = [[1,2], [2,1]]
      expect(knight.prune_moves(board_state, moves)).to eq [[1,2], [2,1]]
    end

    it 'does not return a space which contains an allie' do
      allow(allie).to receive(:color).and_return('white')
      board_state = [[knight,'',''],['','',allie],['','','']]
      moves = [[1,2], [2,1]]
      expect(knight.prune_moves(board_state, moves)).to eq [[2,1]]
    end
  end
end

describe Rook do
  describe '#get_left' do
    subject(:rook) { described_class.new([4,4], 'white') }
    
    it 'returns all tiles to the left' do
      expect(rook.get_left(4,4)).to eq [[4,3],[4,2],[4,1],[4,0]]
    end
  end

  describe '#get_right' do
    subject(:rook) { described_class.new([4,4], 'white') }

    it 'returns all tiles to the right' do
      expect(rook.get_right(4,4)).to eq [[4,5],[4,6], [4,7]]
    end
  end

  describe '#get_up' do
    subject(:rook) { described_class.new([4, 4], 'white') }

    it 'returns all tiles above' do
      expect(rook.get_up(4, 4)).to eq [[3, 4], [2, 4], [1, 4], [0, 4]]
    end
  end

  describe '#get_down' do
    subject(:rook) { described_class.new([4, 4], 'white') }

    it 'returns all tiles below' do
      expect(rook.get_down(4, 4)).to eq [[5, 4], [6, 4], [7, 4]]
    end
  end

  describe '#prune_move' do
    subject(:rook) { described_class.new([0, 0], 'white') }

    context 'There is an enemy' do
      let(:enemy) { double() }

      it 'returns all tiles up to and including enemy' do
        allow(enemy).to receive(:color).and_return('black')
        board_state = [[rook,'',enemy], ['','',''], [enemy,'','']]
        moves = {right: [[0,1], [0,2], [0,3]], down: [[1,0], [2,0], [3,0]]}
        expect(rook.prune_moves(board_state, moves)).to eq [[0,1],[0,2],[1,0],[2,0]]
      end
    end

    context 'There is an allie' do
      let(:allie) { double() }

      it 'returns all tiles up to allie' do
        allow(allie).to receive(:color).and_return('white')
        board_state = [[rook,'',allie], ['','',''], [allie,'','']]
        moves = {right: [[0,1], [0,2], [0,3]], down: [[1,0], [2,0], [3,0]]}
        expect(rook.prune_moves(board_state, moves)).to eq [[0,1],[1,0]]
      end
    end
  end
end

describe King do
  describe '#get_possible_moves' do
    subject(:king) { described_class.new([0,0], 'white') }

    it 'returns all possible moves' do
      expect(king.get_possible_moves).to eq [[1,0], [0,1], [1,1]]
    end
  end

  describe '#prune_moves' do
    subject(:king) { described_class.new([0,0], 'white') }
    let(:enemy) { double() }
    let(:allie) { double() }

    context 'One enemy one allie' do
      it 'returns all up to and including enemy and all up to but allie' do
        allow(enemy).to receive(:color).and_return('black')
        allow(allie).to receive(:color).and_return('white')
        board_state = [[king, allie], [enemy, '']]
        moves = [[0,1], [1,0], [1,1]]
        expect(king.prune_moves(board_state, moves)).to eq [[1,0], [1,1]]
      end
    end
  end
end
