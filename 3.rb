require_relative 'functions'

input = '1b37373331363f78151b7f2b783431333d78397828372d363c78373e783a393b3736'

puts raw_from_bytes(decrypt_single_byte_xor_cipher(bytes_from_hex(input)))
