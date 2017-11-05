require_relative 'functions'

chosen_plaintext = 'yellow submarineyellow submarineyellow submarineyellow submarine'

input = black_box_encrypt(bytes_from_raw(chosen_plaintext))

result = is_encrypted_using_ecb? input

puts 'Encrypted using ECB mode' if result == true
puts 'Encrypted using CBC mode' if result == false
