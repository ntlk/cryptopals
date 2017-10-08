require_relative 'functions'

input = 'YELLOW SUBMARINE'
expected = "YELLOW SUBMARINE\x04\x04\x04\x04"
block_length = 20

output = pkcs7_pad(bytes_from_raw(input), block_length)

raise unless expected == raw_from_bytes(output)
puts 'Success.'
