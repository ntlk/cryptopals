require 'base64'
require 'openssl'

# Conversions

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

def blocks_from_bytes bytes, length
  bytes.each_slice(length).to_a
end

# The rest

def xor_byte_arrays bytes1, bytes2
  bytes1.zip(bytes2.cycle).map do |byte1, byte2|
    byte1 ^ byte2
  end
end

def pkcs7_pad bytes, length
  if bytes.length < length
    pad_count = length - bytes.length
    bytes.fill(pad_count, bytes.length...length)
  else
    bytes
  end
end

def find_single_byte_xor_cipher_key bytes
  possible_keys = 0..255
  possible_keys.max_by do |key|
    result = xor_byte_arrays bytes, [key]
    score_english_similarity result
  end
end

def decrypt_single_byte_xor_cipher bytes
  best_key = find_single_byte_xor_cipher_key bytes
  xor_byte_arrays bytes, [best_key]
end

def score_english_similarity bytes
  raw_from_bytes(bytes).count 'a-z '
end

def find_xor_key_length possible_key_lengths, bytes
  possible_key_lengths.min_by do |length|
    blocks = bytes.each_slice(length)
    distances = blocks.each_cons(2).first(10).map do |block1, block2|
      hamming_distance block1, block2
    end
    (distances.inject(:+) / distances.length.to_f) / length
  end
end

def find_encrypted_by_single_byte_xor_cipher byte_arrays
  decrypted_byte_arrays = byte_arrays.map do |byte_array|
    decrypt_single_byte_xor_cipher(byte_array)
  end

  decrypted_byte_arrays.max_by {|b| score_english_similarity b }
end

def find_repeating_xor_key_for_key_length length, bytes
  blocks = bytes.each_slice(length).to_a
  last_block = blocks.last
  last_block.fill(0, last_block.length, length - last_block.length)
  transposed_blocks = blocks.transpose
  transposed_blocks.map do |bytes|
    find_single_byte_xor_cipher_key bytes
  end
end

def encrypt_repeating_key_xor bytes, key_bytes
  xor_byte_arrays bytes, key_bytes
end

def encrypt_ecb key, bytes
  cipher = OpenSSL::Cipher::AES.new(128, :ECB)
  cipher.decrypt
  cipher.key = key
  bytes_from_raw(cipher.update(raw_from_bytes(bytes)) + cipher.final)
end

def decrypt_ecb key, bytes
  encrypt_ecb key, bytes
end

def hamming_distance bytes1, bytes2
  distance_array = bytes1.zip(bytes2).map do |byte1, byte2|
    bits1 = bits_from_byte byte1
    bits2 = bits_from_byte byte2
    bits1.zip(bits2).count do |bit1, bit2|
      bit1 != bit2
    end
  end
  distance_array.inject(:+)
end
