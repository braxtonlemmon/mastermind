#!/home/braxton/.rbenv/shims/ruby

require_relative 'board'
require_relative 'computer'
require_relative 'player'
require_relative 'rules'

class Game
	include Rules 

	attr_accessor :gameboard, :human, :computer, :answer, :guess
	
	def initialize(gameboard = Board.new)
		@gameboard = gameboard
		@computer = Computer.new
		@answer = computer.generate_pattern
		setup_game { show_rules }
	end

	def setup_game
		puts "Welcome to Mastermind!\n\n"
		puts "Would you like to see the rules? (y/n)"
		yield if gets.chomp.downcase[0] == 'y'
		puts "Ok. Please enter your name:"
		@human = Player.new(gets.chomp)
		puts "\nIt's #{human.name} versus the computer. Let's play!"
		play
	end

	def play
		(1..12).each do |attempt_number|
			puts "\n\nThis is attempt ##{attempt_number}..."
			make_guess
			check_guess
			game_over if win?
		end
		game_over
	end

	def make_guess
		try = []
		until try.size == 4 && try.all? { |x| x.match(/[A-F]/) }
			try = []
			puts "Please enter four letters to make a guess (A-F): "
			try = gets.chomp.upcase.split('')
		end
		puts "\nYou guessed [#{try.join(' ')}]."
		@guess = try
	end

	def check_guess
			pegs = compare_guess_to_pattern
			puts "Black pegs: #{pegs[0]}\nWhite pegs: #{pegs[1]}. \nTry again"
	end

	def compare_guess_to_pattern
		b_pegs = 0
		w_pegs = 0
		key = answer.uniq
		key.each_with_index do |letter|
			if answer.count(letter) == guess.count(letter)
				w_pegs += answer.count(letter)
			elsif answer.count(letter) > guess.count(letter)
				w_pegs += guess.count(letter)
			elsif answer.count(letter) < guess.count(letter)
				w_pegs += answer.count(letter)
			end
		end
		(0..3).each do |i|
			if answer[i] == guess[i]	
				b_pegs += 1
				w_pegs -= 1
			end
		end
		[b_pegs, w_pegs]
	end


	def win?
		guess == answer
	end

	def game_over
		puts win? ? "You win!" : "You lose, sorry."
		# puts "\n\nYou did not guess the correct combination."
		puts "Would you like to play again?"
		gets.chomp.downcase[0] == 'y' ? (game = Game.new) : return
	end		
end

game = Game.new