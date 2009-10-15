require 'spec_helper'

describe "Image h9Guq" do

	before do
		@image_stats = $imgur.image_stats "h9Guq"
	end
	
	it "should be hash of statistics" do
		@image_stats.should.satisfy { |h| h.is_a?(Hash) }
	end

	it "should be 387,469 bytes in size" do
		@image_stats["size"].to_i.should.equal 387469
	end
	
	it "should be type image/png" do
		@image_stats["type"].should.equal "image\/png"
	end
	
end
		
