require 'spec_helper'

describe "A local image" do
	
	it "should first be uploaded" do
		should.not.raise(Imgur::ImgurError) do
			@image = $imgur.upload_file "spec/spec_image.jpg"
		end
	end
	
	it "should be a hash" do
		@image.should.satisfy { |o| o.is_a?(Hash) }
	end
	
	it "should then be deleted" do
		$imgur.delete(@image["delete_hash"]).should.equal true
	end
	
end

describe "A remote image" do

	it "should first be uploaded" do
		should.not.raise(Imgur::ImgurError) do
			@image = $imgur.upload_from_url "http://media.fukung.net/images/20568/4e808393622518e616761bc4a4362f69.jpg"
		end
	end
	
	it "should be a hash" do
		@image.should.satisfy { |o| o.is_a?(Hash) }
	end
	
	it "should then be deleted" do
		$imgur.delete(@image["delete_hash"]).should.equal true
	end
	
end
