require 'spec_helper'

describe "An remote image" do

	it "should first be uploaded" do
		@image = $imgur.upload "http://media.fukung.net/images/20568/4e808393622518e616761bc4a4362f69.jpg"
	end
	
	it "should then be deleted" do
		$imgur.delete @image.delete_hash
	end
	
end
