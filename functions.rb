require 'base64'

def base64_from_hex input
  bytes = bytes_from_hex input
  Base64.strict_encode64(raw_from_bytes bytes)
end

def bytes_from_hex hex
  hex.scan(/../).map(&:hex)
end

def raw_from_bytes bytes
  bytes.map(&:chr).join
end
