require_relative 'functions'

input = File.read('6.txt')

raw_input = raw_from_base64 input
possible_key_lengths = 2..40

test_input1 = 'this is a test'
test_input2 = 'wokka wokka!!!'

raise unless (hamming_distance bytes_from_raw(test_input1), bytes_from_raw(test_input2)) == 37


key_length = find_xor_key_length possible_key_lengths, bytes_from_raw(raw_input)

key = find_repeating_xor_key_for_key_length key_length, bytes_from_raw(raw_input)
output = encrypt_repeating_key_xor bytes_from_raw(raw_input), key

fail unless raw_from_bytes(output).start_with? "I'm back and I'm ringin' the bell"
puts 'Success.'

