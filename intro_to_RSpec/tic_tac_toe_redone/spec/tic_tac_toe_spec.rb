require_relative '../lib/board_class.rb'
require_relative '../lib/player_class.rb'

describe Board do
    describe '#game_over?' do
        subject(:game) { described_class.new() }
        let(:player) { instance_double(Player) }
        
        before do
            allow(player).to receive(:sign).and_return('X')
            allow(player).to receive(:name).and_return('Brady')
            allow(game).to receive(:puts)
        end

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
    end
end

