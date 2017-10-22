require_relative 'functions'

key = 'YELLOW SUBMARINE'
iv = "\x00" * 16
input = File.readlines('10.txt').join

result = raw_from_bytes(decrypt_cbc(bytes_from_raw(raw_from_base64(input)), bytes_from_raw(key), bytes_from_raw(iv)))

fail unless result.start_with? "I'm back and I'm ringin' the bell"
puts "Success."
