desc "Fetches prices and quantity from cavirtex and bitstamp"
task :fetch_prices => :environment do

require 'nokogiri'
require 'open-uri'
require 'net/smtp'
require 'httparty'

#Cavirtex Scraper
url = "https://www.cavirtex.com/orderbook"
doc = Nokogiri::HTML(open(url))
virtexBidPrice = doc.at_css("#orderbook_buy tr td[3]").text.to_f
virtexBidQty = doc.at_css("#orderbook_buy tr td[2]").text.to_f
virtexAskPrice = doc.at_css("#orderbook_sell tr td[3]").text.to_f
virtexAskQty = doc.at_css("#orderbook_sell tr td[2]").text.to_f

#Bitstamp API
response = HTTParty.get("https://www.bitstamp.net/api/order_book")
stampBidPrice = response["bids"].first[0].to_f
stampBidQty = response["bids"].first[1].to_f
stampAskPrice = response["asks"].first[0].to_f
stampAskQty = response["asks"].first[1].to_f

#Trading Logic
lowSpread = stampBidPrice - virtexAskPrice 
maxSpread = stampBidPrice - virtexBidPrice

#Email Message
roundDollar = 2
roundQty = 3
msg = <<MESSAGE_END
MIME-Version: 1.0
Content-type: text/html
Subject: Lowspread: #{lowSpread.round(roundDollar)}, MaxSpread: #{maxSpread.round(roundDollar)}

<table border="1">
	<tbody>
		<tr>
			<th>Exchange</th>
			<th>Bid</th>
			<th>Qty</th>
			<th>Ask</th>
			<th>Qty</th>
		</tr>
		<tr>
			<td>CAVirtex</td>
			<td>#{virtexBidPrice.round(roundDollar)}</td>
			<td>#{virtexBidQty.round(roundQty)}</td>
			<td>#{virtexAskPrice.round(roundDollar)}</td>
			<td>#{virtexAskQty.round(roundQty)}</td>
		</tr>
		<tr>
			<td>Bitstamp</td>
			<td>#{stampBidPrice.round(roundDollar)}</td>
			<td>#{stampBidQty.round(roundQty)}</td>
			<td>#{stampAskPrice.round(roundDollar)}</td>
			<td>#{stampAskQty.round(roundQty)}</td>
		</tr>
	</tbody>
</table>

<h3>Lowspread: #{lowSpread.round(roundDollar)}<br>MaxSpread: #{maxSpread.round(roundDollar)}</h3>

MESSAGE_END


#Email Send Logic
if maxSpread >= 6
	smtp =Net::SMTP.new 'smtp.gmail.com',587
	smtp.enable_starttls
	smtp.start("gmail.com",YourAccountName,YourPassword,:login) do
		smtp.send_message(msg,FromAddress,ToAddress)
	end
end

end
