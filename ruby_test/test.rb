require 'pry'
require 'active_support/all'
require "csv"
require 'time'

DAY_REGEX = /[平日|月|火|水|木|金|土|日|祝|〜|・|曜日]{2,}|全日|平日|月|火|水|木|金|土|日|祝/
HOUR_REGEX = /\d{1,}:\d{1,}/

def date_parse(date_text)
  week_days = ['月', '火', '水', '木', '金', '土', '日', '祝']
  date_text.delete!('・')
  date_text.delete!('曜')
  tmp = date_text.split('〜')

  if tmp.size == 2 && week_days.include?(tmp[0]) && week_days.include?(tmp[1])
    date_text = week_days[week_days.find_index(tmp[0])..week_days.find_index(tmp[1])].join
  end
  # ここに日付を変換する処理を書く
  case date_text
  when /^[月|火|水|木|金]$/
    ['平日']
  when /^[土|日|祝]$/
    [date_text]
  when /^[月|火|水|木|金]+$/
    ['平日']
  when /^[月|火|水|木|金|土]+$/
    ['平日', '土']
  when /^[月|火|水|木|金|日]+$/
    ['平日', '日']
  when /^[月|火|水|木|金|祝]+$/
    ['平日', '祝']
  when /^[月|火|水|木|金|土|日]+$/
    ['平日', '土', '日']
  when /^[月|火|水|木|金|土|日|祝]+$/
    ['平日', '土', '日', '祝']
  when /^[土|日]+$/
    ['土', '日']
  when /^[土|祝]+$/
    ['土', '祝']
  when /^[日|祝]+$/
    ['日', '祝']
  when /^[土|日|祝]+$/
    ['土', '日', '祝']
  when '全日'
    ['平日', '土', '日', '祝']
  else
    [date_text]
  end
end

def map_business_hours(business_hour_text)
  # splitedみたない変数名は適切じゃないので考えたい
  splited = business_hour_text.split(/(#{DAY_REGEX}|休憩時間)/m)

  if splited[0].scan(/#{HOUR_REGEX}/m)
    # 配列の初めに時間がある場合、日付種別の指定がないデータだと思われるので先頭に前日付種別をセット
    splited.unshift('月〜祝')
  end

  splited.map.with_index do |tmp, index|
    next if tmp.scan(/#{DAY_REGEX}/).empty?

    hour_text = splited[index+1]
    next if hour_text.nil?

    business_hours = hour_text.scan(/#{HOUR_REGEX}/m)
    next if business_hours.empty?

    business_hours.map! { |hour| Time.parse(hour) }

    date_parse(tmp).map do |date|
      yield date, business_hours.min, business_hours.max
    end
  end.flatten.compact
end

count = 1

CSV.foreach("#{__dir__}/orders.csv", headers: true, liberal_parsing: true) do |row|
  next if row[1].nil?

  business_hours = map_business_hours(row[1]) do |day, business_hour_min, business_hour_max|
    {
      date: day,
      business_hour_min: business_hour_min.strftime("%H:%M"),
      business_hour_max: business_hour_max.strftime("%H:%M"),
    }
  end
  next if business_hours.empty?

  count += 1
  hoge = business_hours.group_by{ |tmp| tmp[:date] }.map do |key, hours|
    business_hour_min = hours.map {|tmp| tmp[:business_hour_min] }.min
    business_hour_max = hours.map {|tmp| tmp[:business_hour_max] }.max
    "#{key}: #{business_hour_min}〜#{business_hour_max}"
  end

  p [*hoge, row[1]]
end

p count
