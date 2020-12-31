# frozen_string_literal: true

require 'pry'

class Game
end

class Controller
end

# This will keep track of and draw our game board
class Board
  attr_accessor :board_matrix

  def initialize(edge_size)
    @edge_size = edge_size
    @board_matrix = Array.new(edge_size) { Array.new(edge_size, '   ') }
  end

  def draw_board
    # To ensure a third vertical line isn't drawn on the board
    vertical_line = 1
    bottom_line = 0
    bottom_line_string = create_bottom_string

    print "\n"
    @board_matrix.each do |array|
      array.each do |gridspace|
        print vertical_line % @edge_size != 0 ? "#{gridspace}|" : gridspace
        vertical_line += 1
      end
      print bottom_line != @edge_size - 1 ? "\n#{bottom_line_string}\n" : "\n\n"
      bottom_line += 1
    end
  end

  private

  def create_bottom_string
    bottom_line_length = @edge_size * 3 + (@edge_size - 1)
    bottom_line_string = ''

    bottom_line_length.times do
      bottom_line_string += '-'
    end

    bottom_line_string
  end
end

class Player
end

board = Board.new(3)
board.draw_board
