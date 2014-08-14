#!/usr/bin/env ruby

require_relative 'patches'
require_relative 'board'
require_relative 'human_player'

class Checkers
  attr_reader :board

  def initialize(white_player, red_player)
    @board = Board.new
    @players = [white_player, red_player]
    @active_player = @players[0]
  end

  def play
    until game_over?
      render

      begin
        handle_move_seq(get_move_seq)
      rescue InvalidMoveError
        retry
      rescue Interrupt
        puts "Exiting..."
        exit
      end

      switch_turns
    end

    render
    puts "#{winner.name} wins!"
  end

  def game_over?
    @board.pieces_by_color(:white).empty? || @board.pieces_by_color(:red).empty?
  end

  def winner
    return nil unless game_over?
    @board.pieces_by_color?(:white).empty? ? :red : :white
  end

  def render
    puts "\n#{@board}\n"
  end

  def get_move_seq
    @active_player.get_move_seq
  end

  def handle_move_seq(move)

  end

  def switch_turns
    @active_player = (@active_player == @players[0]) ? @players[1] : @players[0]
  end
end

if __FILE__ == $PROGRAM_NAME
  white_player = HumanPlayer.new("White", :white)
  red_player = HumanPlayer.new("Red", :red)
  game = Checkers.new(white_player, red_player)
  game.play
end
