require_relative 'functions'
require 'openssl'

key = 'YELLOW SUBMARINE'
input = File.read('7.txt')

cipher = OpenSSL::Cipher::AES.new(128, :ECB)
cipher.decrypt
cipher.key = key
result = cipher.update(raw_from_base64(input)) + cipher.final

fail unless result.start_with? "I'm back and I'm ringin' the bell"
puts "Success."
