require_relative 'functions'

input = File.readlines('4.txt')

puts find_best_raw_from_single_byte_xor_cipher input
