require 'base64'

def base64_from_hex hex
  bytes = bytes_from_hex hex
  Base64.strict_encode64(raw_from_bytes bytes)
end

def bytes_from_hex hex
  hex.scan(/../).map(&:hex)
end

def bytes_from_raw raw
  raw.bytes
end

def hex_from_bytes bytes
  bytes.map {|byte| byte.to_s(16).rjust(2, '0')}.join
end

def raw_from_bytes bytes
  bytes.map(&:chr).join
end

def raw_from_base64 base64
  Base64.decode64(base64)
end

def raw_from_hex hex
  bytes = bytes_from_hex hex
  raw_from_bytes bytes
end

def bits_from_byte byte
  byte.to_s(2).rjust(8, '0').chars
end

def xor_hexes hex1, hex2
  bytes1 = bytes_from_hex hex1
  bytes2 = bytes_from_hex hex2
  result = xor_byte_arrays bytes1, bytes2
  hex_from_bytes result
end

def xor_byte_arrays bytes1, bytes2
  bytes1.zip(bytes2.cycle).map do |byte1, byte2|
    byte1 ^ byte2
  end
end

def find_single_byte_xor_cipher_key bytes
  possible_keys = 0..255
  possible_keys.max_by do |key|
    result = xor_byte_arrays bytes, [key]
    raw = raw_from_bytes result
    score_english_similarity raw
  end
end

def decrypt_single_byte_xor_cipher hex
  bytes = bytes_from_hex hex
  best_key = find_single_byte_xor_cipher_key bytes
  result = xor_byte_arrays bytes, [best_key]
  raw = raw_from_bytes result
end

def score_english_similarity raw
  raw.count 'a-z '
end

def find_xor_key_length possible_key_lengths, raw
  bytes = bytes_from_raw raw
  possible_key_lengths.min_by do |length|
    blocks = bytes.each_slice(length)
    distances = blocks.each_cons(2).first(10).map do |block1, block2|
      hamming_distance raw_from_bytes(block1), raw_from_bytes(block2)
    end
    (distances.inject(:+) / distances.length.to_f) / length
  end
end

def find_best_raw_from_single_byte_xor_cipher hexes
  raws = hexes.map do |hex|
    decrypt_single_byte_xor_cipher hex
  end

  raws.max_by {|raw| score_english_similarity raw }
end

def find_repeating_xor_key_for_key_length length, raw
  bytes = bytes_from_raw raw
  blocks = bytes.each_slice(length).to_a
  last_block = blocks.last
  last_block.fill(0, last_block.length, length - last_block.length)
  transposed_blocks = blocks.transpose
  key_bytes = transposed_blocks.map do |bytes|
    find_single_byte_xor_cipher_key bytes
  end
  key = raw_from_bytes key_bytes
end

def encrypt_repeating_key_xor raw, raw_key
  bytes = bytes_from_raw raw
  bytes_key = bytes_from_raw raw_key
  result = xor_byte_arrays bytes, bytes_key
  hex_from_bytes result
end

def hamming_distance raw1, raw2
  bytes1 = bytes_from_raw raw1
  bytes2 = bytes_from_raw raw2
  distance_array = bytes1.zip(bytes2).map do |byte1, byte2|
    bits1 = bits_from_byte byte1
    bits2 = bits_from_byte byte2
    bits1.zip(bits2).count do |bit1, bit2|
      bit1 != bit2
    end
  end
  distance_array.inject(:+)
end
