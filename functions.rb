require 'base64'

def base64_from_hex input
  bytes = bytes_from_hex input
  Base64.strict_encode64(raw_from_bytes bytes)
end

def bytes_from_hex hex
  hex.scan(/../).map(&:hex)
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
  bytes1.map.with_index do |byte, idx|
    byte ^ bytes2[idx]
  end
end

