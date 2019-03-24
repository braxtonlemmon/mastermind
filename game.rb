#!/home/braxton/.rbenv/shims/ruby

require_relative 'board'
require_relative 'computer'
require_relative 'player'
require_relative 'rules'

class Game
	include Rules 

	attr_accessor :gameboard, :human, :computer, :answer, :guess, :history
	
	def initialize(gameboard = Board.new)
		@gameboard = gameboard
		@computer = Computer.new
		@answer = computer.generate_pattern
		@history = []
		setup_game { show_rules }
	end

	def choose_role
		until choice.between?(1..2)
			choice = 0
			puts "Which role do you want?\nPress (1) to be CODEMAKER or press (2) to be CODEBREAKER"
			choice = gets.chomp.to_i
		end
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
			show_history if attempt_number > 1
			make_guess
			check_guess
			break if win?
		end
		play_again? ? (game = Game.new) : return
	end

	def make_guess
		try = []
		until try.size == 4 && try.all? { |x| x.match(/[A-F]/) }
			try = []
			puts "Please enter four letters to make a guess (A-F): "
			try = gets.chomp.upcase.split('')
		end
		puts "\nYou guessed:    [#{try.join(' | ')}]"
		@guess = try
	end

	def check_guess
			pegs = compare_guess_to_pattern
			@history << [guess, pegs]
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

	def show_history
		puts "******************************************************************"
		history.each_with_index do |try, i|
			puts "Guess #{i+1}: [#{try[0].join(' | ')}].................Black pegs: #{try[1][0]} | White pegs: #{try[1][1]}"
		end
		puts "******************************************************************"
	end

	def win?
		guess == answer
	end

	def play_again?
		puts "Correct answer: [#{answer.join(' | ')}]"
		puts win? ? "You win!" : "You lose, sorry."
		puts "Would you like to play again?"
		gets.chomp.downcase[0] == 'y' ? true : false
	end		
end

game = Game.new