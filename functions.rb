require 'base64'

def base64_from_hex input
  bytes = bytes_from_hex input
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

def decrypt_single_byte_xor_cipher hex
  possible_keys = 0..255
  bytes = bytes_from_hex hex
  best_key = possible_keys.max_by do |key|
    result = xor_byte_arrays bytes, [key]
    raw = raw_from_bytes result
    score_english_similarity raw
  end

  result = xor_byte_arrays bytes, [best_key]
  raw = raw_from_bytes result
end

def score_english_similarity raw
  raw.count 'a-z'
end

def find_best_raw_from_single_byte_xor_cipher hexes
  raws = hexes.map do |hex|
    decrypt_single_byte_xor_cipher hex
  end

  raws.max_by {|raw| score_english_similarity raw }
end

def encrypt_repeating_key_xor raw, raw_key
  bytes = bytes_from_raw raw
  bytes_key = bytes_from_raw raw_key
  result = xor_byte_arrays bytes, bytes_key
  hex_from_bytes result
end
