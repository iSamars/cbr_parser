require 'faraday'
require 'nokogiri'
require 'csv'

date_month_ago = (Date.today - 30).strftime('%d/%m/%Y')
date_now = Date.today.strftime('%d/%m/%Y')

begin
  doc = Faraday.get("http://www.cbr.ru/scripts/XML_dynamic.asp?date_req1=#{date_month_ago}&date_req2=#{date_now}&VAL_NM_RQ=R01235").body
rescue StandardError
  puts 'Connection error!'
end

xml = Nokogiri::Slop(doc)

CSV.open('data.csv', 'w', write_headers: true, headers: %w[date value]) do |csv|
  xml.xpath('//Record').each do |rec|
    csv << [rec['Date'], rec.Value.content]
  end
end

print "Result exported to the file data.csv"
