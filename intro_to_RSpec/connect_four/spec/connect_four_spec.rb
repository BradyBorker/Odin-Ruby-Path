require_relative '../lib/rack_class.rb'
require_relative '../lib/player_class.rb'
require 'colorize'

describe Rack do
    describe '#place_token' do
        subject(:game) { described_class.new }
        let(:player) { Player.new('Name', :red) }

        context 'When rack is empty' do
            it 'places token on bottom row' do
                allow(game).to receive(:empty_slot?).and_return(true)
                game.place_token(player, 0)
                expect(game.instance_variable_get(:@rack)[5][0]).to eq player.token
            end
        end

        context 'When rack has one slot filled' do
            it 'places token on top of other token' do
                allow(game).to receive(:empty_slot?).and_return(false, true)
                game.place_token(player, 0)
                expect(game.instance_variable_get(:@rack)[4][0]).to eq player.token
            end
        end
    end

    describe '#empty_slot?' do
        subject(:game) { described_class.new }
        let(:player) { Player.New('Name', :red) }

        context 'When slot is empty' do
            it 'returns true' do
                game.instance_variable_set(:@rack, [['O','O'],['O','O']])
                expect(game.empty_slot?(0,0)).to be true
            end
        end

        context 'When slot is not empty' do
            it 'does not return true' do
                game.instance_variable_set(:@rack, [['O'.colorize(:red),'O'],['O','O']])
                expect(game.empty_slot?(0,0)).to_not be true
            end
        end
    end

    describe '#not_in_range?' do
        subject(:game) { described_class.new }

        context 'Column is within range' do
            it 'does not return true' do
                expect(game.not_in_range?(3)).to_not be true
            end
        end

        context 'Column is not within range' do
            it 'returns true when > 6' do
                expect(game.not_in_range?(10)).to be true
            end

            it 'returns true when < 0' do
                expect(game.not_in_range?(-1)).to be true
            end
        end
    end

    describe '#game_over?' do
      subject(:game) { described_class.new }

      before do
          allow(game).to receive(:check_vertical)
          allow(game).to receive(:check_negative_diag)
          allow(game).to receive(:check_positive_diag)
      end

      context 'One of the checks (check_horizontal, check_vertical, etc) is true' do
        it 'returns true' do
          game.instance_variable_set(:@first_call, false)
          allow(game).to receive(:check_horizontal).and_return(true)
          expect(game.game_over?).to be true
        end
      end

      context 'None of the checks are true' do
        it 'returns false' do
          allow(game).to receive(:check_horizontal)
          expect(game.game_over?).to_not be true
        end
      end
    end

    describe '#check_horizontal' do
      subject(:game) { described_class.new }

      context 'When four of the same tokens are connected horizontally' do
        it 'returns true' do 
          red = 'O'.colorize(:red)
          game.instance_variable_set(:@last_token, [0,0])
          game.instance_variable_set(:@rack, [[red,red,red,red], ['O','O','O','O']])
          expect(game.check_horizontal).to be true
        end

        it 'looks both ways' do
          red = 'O'.colorize(:red)
          game.instance_variable_set(:@last_token, [0,2])
          game.instance_variable_set(:@rack, [[red,red,red,red], ['O','O','O','O']])
          expect(game.check_horizontal).to be true
        end
      end
    end

    describe '#check_vertical' do
      subject(:game) { described_class.new }

      context 'When four tokens are connected vertically' do
        it 'returns true' do
          red = 'O'.colorize(:red)
          game.instance_variable_set(:@last_token, [0,0])
          game.instance_variable_set(:@rack, [[red, 'O'], [red, 'O'], [red, 'O'], [red, 'O']])
          expect(game.check_vertical).to be true
        end
      end

      context 'When it goes out of bounds' do
        it 'does not return true' do
          red = 'O'.colorize(:red)
          game.instance_variable_set(:@last_token, [3,0])
          game.instance_variable_set(:@rack, [['O', 'O'], ['O', 'O'], ['O', 'O'], [red, 'O'], [red,'O'], [red, 'O']])
          expect(game.check_vertical).not_to be true
        end
      end
    end

    describe '#check_positive_diag' do
        subject(:game) { described_class.new }

        context 'connects in pos diagonal' do
            it 'returns true' do
                red = 'O'.colorize(:red)
                game.instance_variable_set(:@last_token, [3,0])
                game.instance_variable_set(:@rack, [['O', 'O','O',red], ['O', 'O',red,'O'], ['O', red,'O','O'], [red, 'O','O','O'], ['O', 'O','O','O'], ['O', 'O','O','O']])
                expect(game.check_positive_diag).to be true
            end

            it 'looks both ways and returns true' do
                red = 'O'.colorize(:red)
                game.instance_variable_set(:@last_token, [1,2])
                game.instance_variable_set(:@rack, [['O', 'O','O',red], ['O', 'O',red,'O'], ['O', red,'O','O'], [red, 'O','O','O'], ['O', 'O','O','O'], ['O', 'O','O','O']])
                expect(game.check_positive_diag).to be true
            end
        end
    end

    describe '#check_negative_diag' do
        subject(:game) { described_class.new }

        context 'connects in neg diagonal' do 
            it 'returns true' do 
                red = 'O'.colorize(:red)
                game.instance_variable_set(:@last_token, [0,0])
                game.instance_variable_set(:@rack, [[red, 'O','O','O'], ['O', red,'O','O'], ['O','O',red,'O'], ['O', 'O','O',red], ['O', 'O','O','O'], ['O', 'O','O','O']])
                expect(game.check_negative_diag).to be true
            end

            it 'looks both ways and returns true' do
                red = 'O'.colorize(:red)
                game.instance_variable_set(:@last_token, [1,1])
                game.instance_variable_set(:@rack, [[red, 'O','O','O'], ['O', red,'O','O'], ['O','O',red,'O'], ['O', 'O','O',red], ['O', 'O','O','O'], ['O', 'O','O','O']])
                expect(game.check_negative_diag).to be true
            end
        end
    end
end