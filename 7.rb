require_relative 'functions'

key = 'YELLOW SUBMARINE'
input = File.read('7.txt')
bytes = bytes_from_raw(raw_from_base64(input))

result = raw_from_bytes(decrypt_ecb(bytes_from_raw(key), bytes))

fail unless result.start_with? "I'm back and I'm ringin' the bell"
puts "Success."
