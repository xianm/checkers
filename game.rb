#!/usr/bin/env ruby

require_relative 'patches'
require_relative 'errors'
require_relative 'board'
require_relative 'human_player'

class Checkers
  attr_reader :board

  def initialize(white_player, red_player)
    @board = Board.new
    @players = {
      :white => white_player,
      :red => red_player
    }
    @active_player = :white
  end

  def play
    until game_over?
      render

      begin
        handle_move_seq(get_move_seq)
      rescue InvalidMoveError => error
        puts error.message
        retry
      rescue Interrupt
        exit
      end

      switch_turns
    end

    render
    puts "#{winner.name} wins!"
  end

  def game_over?
    winner
  end

  def winner
    return @players[:white] if white_has_won?
    return @players[:red] if red_has_won?
    nil
  end

  def white_has_won?
    @board.pieces_by_color(:red).empty? ||
      (@active_player == :red && @board.player_is_blocked?(:red))
  end

  def red_has_won?
    @board.pieces_by_color(:white).empty? ||
      (@active_player == :white && @board.player_is_blocked?(:white))
  end

  def render
    puts "\n#{@board}\n"
  end

  def get_move_seq
    active_player.get_move_seq
  end

  def handle_move_seq(move_seq)
    @board.try_move_seq(active_player.color, move_seq)
  end

  def active_player
    @players[@active_player]
  end

  def switch_turns
    @active_player = (@active_player == :white) ? :red : :white
  end
end

if __FILE__ == $PROGRAM_NAME
  white_player = HumanPlayer.new("White", :white)
  red_player = HumanPlayer.new("Red", :red)
  game = Checkers.new(white_player, red_player)
  game.play
end
