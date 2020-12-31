# frozen_string_literal: true

require 'pry'


# Creates players/board and passes to a controller, tracks game behavior
class Game
  @@count_turns = 0

  def initialize(num_of_players, edge_size)
    @is_game_over = false
    @board = Board.new(edge_size)
    @controller = Controller.new(num_of_players)
  end

  #game loop: draw, get input, update board, check game over
  #if @is_game_over then end_game
  def start_game
    puts 'GAME STARTED'
    while !@is_game_over
      @@count_turns += 1
      @board.draw_board
      @board.update_board(@controller.get_input)
      is_game_over
    end
    puts @@count_turns
    end_game
  end

  def is_game_over
    b = @board.board_matrix
    #ROWS
    if b[0][0] == b[0][1] &&  b[0][1] == b[0][2]
      @is_game_over = true
    elsif b[1][0] == b[1][1] &&  b[1][1] == b[1][2]
      @is_game_over = true
    elsif b[2][0] == b[2][1] &&  b[2][1] == b[2][2]
      @is_game_over = true
    #COLUMNS
    elsif b[0][0] == b[1][0] &&  b[1][0] == b[2][0]
      @is_game_over = true
    elsif b[0][1] == b[1][1] &&  b[1][1] == b[2][1]
      @is_game_over = true
    elsif b[2][0] == b[2][1] &&  b[2][1] == b[2][2]
      @is_game_over = true
    #DIAGONALS
    elsif b[0][0] == b[1][1] &&  b[1][1] == b[2][2]
      @is_game_over = true
    elsif b[2][0] == b[1][1] &&  b[1][1] == b[0][2]
      @is_game_over = true
    elsif @@count_turns==9
      @is_game_over = true
    end
  end

  def end_game
    @board.draw_board
    puts 'GAME OVER!'
    if @@count_turns==9
      puts "IT'S A DRAW!"
    else
      puts "#{@controller.player_to_go.name} is the winner!!"
    end
  end
end

# Creates players and controls input
class Controller
  attr_reader :player_to_go

  def initialize(players)
    @players = create_players(players)
    @player_to_go = @players[1]
    @stored_guesses = []
  end

  def create_players(players)
    players = Array.new(players)
    players.each_index { | i | players[i] = Player.new("Player #{i+1}") }
  end

  def get_input
    switch_player_turn
      puts "It is #{@player_to_go.name}'s turn to go!\nEnter which square you want to fill!\n"
      letter = test_input
      return [" #{letter} ", @player_to_go.name]
  end

  def switch_player_turn
    if @player_to_go == @players[0]
      @player_to_go = @players[1]
    else
      @player_to_go = @players[0]
    end
  end

  def test_input
    test_passed = false

    while test_passed == false
      letter = gets.chomp.upcase
      if letter >= "A" and letter <= "I" and !@stored_guesses.include?(letter)
        test_passed = true
        @stored_guesses.push(letter)
      end
    end
    return letter
  end
end

# This will keep track of board matrix, symbols, and draw our game board
class Board
  attr_accessor :board_matrix

  def initialize(edge_size)
    @edge_size = edge_size
    @board_matrix = Array.new(edge_size) { Array.new(edge_size, '   ') }
    new_board_grid
  end

  def draw_board
    # To ensure a third vertical line isn't drawn on the board
    vertical_line = 1
    bottom_line = 0
    bottom_line_string = create_bottom_string
    translate_matrix

    print "\n"
    @board_matrix.each do |array|
      array.each do | element |
        print vertical_line % @edge_size != 0 ? "#{element}|" : element
        vertical_line += 1
      end
      print bottom_line != @edge_size - 1 ? "\n#{bottom_line_string}\n" : "\n\n"
      bottom_line += 1
    end
  end

  def update_board(grid_player_name_array)
    letter = grid_player_name_array[0]
    symbol = grid_player_name_array[1] === "Player 1" ? " X " : " O "
    x = 0
    y = 0

    # Translates letter input into coordinate
    @board_matrix.each_index do | i |
      @board_matrix.each_index do | j |
        if @board_matrix[i][j] == letter
          x = i
          y = j
        end
      end
    end

    @board_matrix[x][y] = symbol
  end

  private

  # Creates initial board with letters to show users for input
  def new_board_grid
    unicode = 65
    @board_matrix.each do | array |
      @board_matrix.each_with_index do | element, i |
        array[i] = " #{unicode.chr} "
        unicode += 1
      end
    end
  end


  def create_bottom_string
    bottom_line_length = @edge_size * 3 + (@edge_size - 1)
    bottom_line_string = ''

    bottom_line_length.times do
      bottom_line_string += '-'
    end

    bottom_line_string
  end

  # Turns numbers into symbols
  def translate_matrix
    @board_matrix.each do | array |
      array.each_with_index do | element, i |
        case element
        when 0
          array[i] = " O "
        when 1
          array[i] = " X "
        end
      end
    end
  end
end

# Has name
class Player
  attr_reader :name
  attr_accessor :turn_to_go
  def initialize(name)
    @name = name
    @turn_to_go = false;
  end
end

game = Game.new(2, 3)
game.start_game