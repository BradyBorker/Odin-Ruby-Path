require_relative '../lib/board_class.rb'
require_relative '../lib/player_class.rb'

describe Board do
    subject(:game) { described_class.new() }
    let(:player) { instance_double(Player) }
    
    before do
        allow(player).to receive(:sign).and_return('X')
        allow(player).to receive(:name).and_return('Brady')
        allow(game).to receive(:puts)
    end

    describe '#game_over?' do
        context 'XXX across top row' do
            it 'returns true' do
                game.instance_variable_set(:@board, ['X','X','X','4','5','6','7','8','9'])
                expect(game.game_over?(player)).to be true
            end
        end

        context 'XXX in a column' do
            it 'returns true' do
                game.instance_variable_set(:@board, ['X','2','3','X','5','6','X','8','9'])
                expect(game.game_over?(player)).to be true
            end
        end

        context 'XXX in a diagnal' do
            it 'returns true' do 
                game.instance_variable_set(:@board, ['X','2','3','4','X','6','7','8','X'])
                expect(game.game_over?(player)).to be true
            end
        end

        context 'When game is not over' do
            it 'returns false' do
                game.instance_variable_set(:@board, ['X','2','X','4','5','6','7','8','9'])
                expect(game.game_over?(player)).to_not be true
            end
        end

        context 'When spaces remaining is 0' do
            it 'returns true' do
                game.instance_variable_set(:@spaces_remaining, 0)
                expect(game.game_over?(player)).to be true
            end
        end
    end

    describe '#valid_move?' do 
        context 'When input is valid range and space is empty' do 
            it 'returns true' do 
                game.instance_variable_set(:@board, ['X','2','X','4','5','6','7','8','9'])
                expect(game.valid_move?(1)).to be true
            end
        end

        context 'When input is valid range but space is not empty' do
            it 'returns false' do
                game.instance_variable_set(:@board, ['X','X','X','4','5','6','7','8','9'])
                expect(game.valid_move?(1)).not_to be true
            end
        end

        context 'When input is out of range' do
            it 'returns false' do 
                game.instance_variable_set(:@board, ['X','2','X','4','5','6','7','8','9'])
                expect(game.valid_move?(100)).not_to be true
            end
        end
    end

    describe '#make_move' do
        it 'Places an X where the user specifies' do
            allow(game).to receive(:print_board)
            allow(game).to receive(:gets).and_return("1\n")
            game.make_move(player)
            expect(game.instance_variable_get(:@board)).to eq ['X','2','3','4','5','6','7','8','9']
        end
    end
end

