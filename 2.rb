require_relative 'functions'

input = '1c0111001f010100061a024b53535009181c'
input2 = '686974207468652062756c6c277320657965'
expected = '746865206b696420646f6e277420706c6179'

actual = xor_hexes input, input2

fail unless actual == expected
puts 'Success.'
