#!/usr/bin/env ruby
#
# This is a sudoku solver which is implemented with a functional style.
# It reads its parameters from stdin.
# you can run it with the following command
# ruby sudoku-functional.rb < in.txt
# You can see the input format in in.txt file


# The main recursive function it accepts a sudoku board (an array [] with 81 elements)
# and returns a list of sudoku boards ([[],[],[]])
def solve(matrix)
	if is_solved matrix
		# this is the bottom case 
		[matrix]
	else
		# We try every possible number from 1 to 9 if it is a valid move
		# And call solve with that number
		# and merge all solutions into one list of boards
		(1..9).select { |number| is_pos_ok(matrix, free_pos(matrix), number) }
			  .map { |num| solve( set_number_at(matrix, free_pos(matrix)[0], num) ) }
			  .inject([]) {|sum, el| sum + el}
	end
end

# Finds the first free position. This is index which has value of zero
def free_pos(matrix)
	matrix.each_index.select {|i| matrix[i] == 0}.take 1
end

# A board is solved when it contains no zero elements
def is_solved(matrix)
	!matrix.empty? && matrix.select {|el| el == 0}.empty?
end

# return a new board with the number at pos replaced with parameter number
def set_number_at(matrix, pos, number)
	matrix.take(pos) + [ number ] + matrix.drop(pos + 1)
end

# A move is a valid one if it does not violate the rules
# for rows, columns and small squares
def is_pos_ok(matrix, pos, number)
	!pos.empty? &&
	is_col_ok(matrix, pos[0], number) &&
	is_row_ok(matrix, pos[0], number) &&
	is_small_ok(matrix, pos[0], number)
end

# check if the number exists at the column of parameter pos
def is_col_ok(matrix, pos, number)
	!matrix.values_at(* matrix.each_index.select {|i| i % 9 == pos % 9}).include? number
end

# check if the number exists at the row of parameter pos
def is_row_ok(matrix, pos, number)
	!matrix.values_at(* matrix.each_index.select {|i| i / 9 == pos / 9}).include? number
end

# check if the number exists at the small square of parameter pos
def is_small_ok(matrix, pos, number)
	!matrix.values_at(* matrix.each_index.select do |i| 
		(i / 9) / 3 == (pos / 9) / 3 && (i % 9) / 3 == (pos % 9) / 3
	end).include? number
end

def read_from_stdin
	matrix = Array.new(9) {Array.new(9, 0) }
	ARGF.each_with_index do |line, index|
		break if index >= 9
	    splits = line.split(' ')
	    splits.each_index {|i| matrix[index][i] = splits[i].to_i  }
	end
	matrix.flatten
end

def print(list)
	list.each do |m|
		m.each_slice(9) {|x| p x}
		puts "-----------------------------"
	end
end

print solve read_from_stdin 

