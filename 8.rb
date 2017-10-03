require_relative 'functions'

input = File.readlines('8.txt')

ecb_encoded_input = input.select do |hex|
  bytes = bytes_from_hex hex
  blocks = blocks_from_bytes bytes, 16
  duplicates = blocks.detect {|e| blocks.count(e) > 1}
end

puts 'Found the ECB encrypted hex: ' + ecb_encoded_input[0]

