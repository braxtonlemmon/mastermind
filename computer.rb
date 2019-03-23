#!/home/braxton/.rbenv/shims/ruby

class Computer
	attr_accessor :score

	def initialize
		@score = 0
	end

	def generate_pattern
		code_pegs = {
			0 => "A",
			1 => "B",
			2 => "C",
			3 => "D",
			4 => "E",
			5 => "F"
		}
		pattern = (1..4).map { code_pegs[rand(6)]}
	end
end
