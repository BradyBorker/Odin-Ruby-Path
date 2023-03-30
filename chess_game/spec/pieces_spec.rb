require_relative '../lib/pieces/pawn_class'
require_relative '../lib/pieces/bishop_class'

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
        pawn.instance_variable_set(:@first_move, true)
        pawn.instance_variable_set(:@position, [2,1])

        board_state = [['', ' ', ''], [' ', ' ', ' '], [' ', ' ', ' ']]
        expect(pawn.prune_moves(board_state, [[1,1], [1,0], [1,2], [0, 1]])).to eq [[1,1],[0,1]]
      end
    end

    context 'Has not moved yet but is being blocked' do
      it 'returns an empty list' do
        pawn.instance_variable_set(:@first_move, true)
        pawn.instance_variable_set(:@position, [2,1])
        allow(enemy).to receive(:color).and_return(:black)

        board_state = [['', ' ', ''], [' ', enemy, ' '], [' ', ' ', ' ']]
        expect(pawn.prune_moves(board_state, [[1,1], [1,0], [1,2], [0, 1]])).to eq []
      end
    end

    context 'Has not moved yet but enemy is two spaces away' do
      it 'returns one move' do
        pawn.instance_variable_set(:@first_move, true)
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

end