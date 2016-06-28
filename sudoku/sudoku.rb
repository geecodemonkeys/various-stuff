#!/usr/bin/ruby

# This is a simple sudoku solver. You can see the input format 
# in the file in.txt
# You can run this code with the following command on Linux
# ./sudoku.rb < in.txt
class Sudoku
	attr_reader :cols
	attr_reader :rows
	attr_reader :small
	attr_reader :matrix

	def initialize()

		@matrix = Array.new(9) {Array.new(9, 0) } 
		@cols = Array.new(9) {Array.new(9, 0)}
		@rows = Array.new(9) {Array.new(9, 0)}
		@small = Array.new(3) {Array.new(3) {Array.new(9, 0) } }
	end

	def readFromStdin()
		ARGF.each_with_index do |line, index|
			break if index >= 9
		    splits = line.split(' ')
		    splits.each_index {|i| @matrix[index][i] = splits[i].to_i  }
		end

		for i in 0...9
			for j in 0...9
				n = @matrix[i][j]
				if n == 0
					next
				end
				idx = n - 1
				@rows[i][idx] = n
				@cols[j][idx] = n
				@small[i / 3 ][ j / 3][idx] = n
			end
		end
	end

	def solve()
		row = 0
		col = 0
		found = false
		@matrix.each_index do |i|
			@matrix[i].each_index do |j|
				if matrix[i][j] == 0
					row = i
					col = j
					found = true
					break
				end 
			end
		end

		if !found
			return true 
		end

		for number in 1..9
			index = number - 1
			if @rows[row][index] != 0 || @cols[col][index] != 0 || @small[row / 3][col / 3][index] != 0
				next
			end
			@rows[row][index] = number
			@cols[col][index] = number
			@small[row / 3][col / 3][index] = number
			@matrix[row][col] = number
			if solve()
				return true
			end
			@matrix[row][col] = 0
			@rows[row][index] = 0
			@cols[col][index] = 0
			@small[row / 3][col / 3][index] = 0
		end

		return false

	end
end

$s = Sudoku.new
$s.readFromStdin
$s.solve

$s.matrix.each {|x| puts "#{x}"}
