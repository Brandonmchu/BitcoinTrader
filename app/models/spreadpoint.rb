class Spreadpoint < ActiveRecord::Base

	attr_accessible :virtexBidPrice, :virtexBidQty, :virtexAskPrice, :virtexAskQty, :stampBidPrice, :stampBidQty, :stampAskPrice, :stampAskQty, :lowSpread, :maxSpread

end
