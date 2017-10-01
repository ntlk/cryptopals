require_relative 'functions'

input = File.readlines('4.txt')

byte_arrays = input.map {|hex| bytes_from_hex(hex)}
puts raw_from_bytes(find_encrypted_by_single_byte_xor_cipher byte_arrays)
