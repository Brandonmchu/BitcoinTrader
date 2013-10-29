class SpreadpointsController < ApplicationController

def index
	@spreadpoint = Spreadpoint.all.order("created_at ASC")
end
end
