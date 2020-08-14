class Board
    def initialize(size)
      @size = size
    end
  
    public
    def make_board
      @game_board = Array.new(@size*@size, " ")
      @turns = 0
      @game_end = false
      @winner = false
    end
  
    def update_board(coordinates, player)
      @game_board[coord_to_array(coordinates)] = player
      @turns += 1
    end
  
    def draw_board
      print "     "
      for i in 1..@size 
        print "x#{i.to_s.rjust(3, "0")} "
      end
      puts "\n    ╔══" + (("══╦══") * (@size - 1)) + "══╗"
      for x in 1..@size
        print "y#{x.to_s.rjust(3, "0")}"
        for y in 1..@size
          coords = [y, x]
          print "║ #{@game_board[coord_to_array(coords)]}  " 
        end
        puts "║"
        if (x < @size)
          puts "    ╠══" + ("══╬══" * (@size -1)) + "══╣"
        end
      end
      puts "    ╚══" + (("══╩══") * (@size - 1)) + "══╝"
    end
    
    def get_nums
      success = false
      until success
        print "Play by giving coordinates to the square you wish to play at: 'x, y':"
        string = gets.chomp
        input = string.scan(/\b[0-9]+\b/)
        if input.length == 2
            input[0] = input[0].to_i
            input[1] = input[1].to_i
          if (check_valid?(input))
            success = true
          end
        else
          puts "\nPlease give one x and one y coordinate\n"
        end
      end
      return input
    end
  
    def done?
      #Game is not done unless end conditions are met
  
      if @turns > @size && @game_end == false
        if (@turns >= @size * @size)
          @game_end = true 
        end
        unless @game_end
          vert_container = verticals
          horz_container = horizontals
          diag_container = diagonals
  
  
          vert_container.each do |array|
            @game_end = true if @game_board.values_at(*array).all? { |square| square == :X}
            @game_end = true if @game_board.values_at(*array).all? { |square| square == :O}
            @winner = true if @game_end
          end
  
          horz_container.each do |array|
            @game_end = true if @game_board.values_at(*array).all? { |square| square == :X}
            @game_end = true if @game_board.values_at(*array).all? { |square| square == :O}
            @winner = true if @game_end
          end
  
          diag_container.each do |array|
            @game_end = true if @game_board.values_at(*array).all? { |square| square == :X}
            @game_end = true if @game_board.values_at(*array).all? { |square| square == :O}
            @winner = true if @game_end
          end
        end
      end
      if @game_end == true && @winner == true
        puts "Winner is you!!!!"
      elsif @game_end == true
        puts "Tie game :|"
      end
  
      return @game_end
    end
  
    private
    #Check to see board position is not taken and given x and y coordinates fit board parameters
    def check_valid?(coordinates)
      valid = false
      x = coordinates[0]
      y = coordinates[1]
      if (x > 0 && x <= @size) && (y > 0 && y <= @size)
        if @game_board[coord_to_array(coordinates)] == " "
          valid = true
        else
          puts "\nLocation already taken! Please try again."
        end
      else
        puts "\nInput does not fit parameters of the board. Please try again."
      end
      return valid
    end
  
    #Convert coordinates into corresponding index of array
    def coord_to_array(coordinates)
      x = coordinates[1]
      y = coordinates[0]
      conversion = ((x-1) * @size) + (y -1)
    end
  
    #return one array containing @size number of arrays to check for vertical positions
    def verticals
      container = Array.new(@size, Array.new)
      container.each_index do |x|
        vert_array = []
        for i in 0..@size-1
          vert_array << (i * @size) + x
        end
        container[x] = vert_array
      end
      return container
    end
  
    #return one array containing @size number of arrays to check horizontal positions
    def horizontals
      container = Array.new(@size, Array.new)
      container.each_index do |x|
        horiz_array = []
        for i in 0..@size-1
          horiz_array << (i) + x * @size
        end
        container[x] = horiz_array
      end
      return container
    end
  
    #return one array containing two arrays of diagonal using size of board
    def diagonals
      container = Array.new()
      diag_array_1 = []
      diag_array_2 = []
      for i in 0..@size-1
        diag_array_1 << i * (@size+1) 
      end
      for i in 0..@size-1
        diag_array_2 << (i * (@size-1)) + @size-1
      end
      container << diag_array_1
      container << diag_array_2
      return container
    end
  end
  
  class Game
    def initialize(size, first_player, second_player)
      @board = Board.new(size)
      @player_1 = Player.new(first_player)
      @player_2 = Player.new(second_player)
      @player_turn = 1
      @game_count = 0
    end
    
    def game_start
      @game_count += 1
      @board.make_board
      playGame
    end
  
    def gameActive
      
    end
  
    #Alternate player that starts every other game
    def set_turns
      if @game_count % 2 == 1
        @player_turn = 1
        @player_1.symbol = :X
        @player_2.symbol = :O
      else
        @player_turn = 2
        @player_1.symbol = :O
        @player_2.symbol = :X
      end
    end
  
    def playGame 
      set_turns
      @board.draw_board
      until @board.done?
        case @player_turn
        when 1
          puts "#{@player_1.name}'s turn!"
          coords = @board.get_nums
          #clear screen command
          puts "\e[H\e[2J"
          @board.update_board(coords, @player_1.symbol)
          @board.draw_board
        when 2
          puts "#{@player_2.name}'s turn!"
          coords = @board.get_nums
          puts "\e[H\e[2J"
          @board.update_board(coords, @player_2.symbol)
          @board.draw_board
        end
        @player_turn = (@player_turn == 1) ? 2 : 1
      end
    end
  end
  
  class Player
    attr_reader :name
    attr_accessor :symbol
    attr_accessor :score
  
    def initialize(name)
      @name = name
      @score = 0
      @symbol = ""
    end
  end
  
  #puts "Welcome, what is your name?"
  #first_player = gets.chomp
  
  puts "WELCOME TO TIC-TAC-TOE!"
  puts "How big of a board would you like to play on? (Limit 3 - 9)"
  size = gets.chomp.to_i
  
  #puts "What is the second player's name?"
  #second_player = gets.chomp
  puts "\e[H\e[2J"
  #if (size > 2 && size < 10)
  #  game = Game.new(size, "Rinn (X)", "Also Rinn (O)")
  #  game.game_start
  
  