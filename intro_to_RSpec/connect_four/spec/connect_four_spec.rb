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

      context 'One of the checks (check_horizontal, check_vertical, etc) is true' do
        it 'returns true' do
          allow(game).to receive(:check_horizontal).and_return(true)
          expect(game.game_over?).to be true
        end
      end

      context 'None of the checks are true' do
        it 'returns false' do
          expect(game.game_over?).to_not be true
        end
      end
    end

    describe '#check_horizontal' do
      subject(:game) { described_class.new }

    end
end