require_relative 'utils/common'

# match
str = '荒木さんは絶好調。藤田は絶好調さん'

matched = str.match(/.{2}\{さん/) # 最短一致

p matched