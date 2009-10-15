require 'httparty'

# @author Justin Poliey
module Imgur

	# General Imgur error container
	class ImgurError < StandardError
		
		def initialize data
			@data = data
			super
		end
		
	end

	# Imgur API interface
	class API
		include HTTParty

		base_uri 'imgur.com/api'
		format :json

		# Creates a new Imgur API instance
		#
		# @param [String] api_key Your API key from http://imgur.com/register/api/
		# @return [Imgur] An Imgur API instance
		def initialize api_key
			@api_key = api_key
		end

		# Uploads an image from local disk, a Base64 encoded string, or a URL
		#
		# @param [String] image The image data. If uploading from local disk, prefix the filename with an @
		# @return [Hash] Information pertaining to the image
		def upload image
			options = { :query => { :key => @api_key, :image => image } }
			response = self.class.post('/upload.json', options)
			response[:rsp]
		end

		# Returns a set of images in gallery format based on your specifications
		#
		# @param [Hash] params Query string parameters to pass
		# @option params [String] :sort Sort order, values are `:latest` or `:popular`
		# @option params [String] :view Date limit, values are `:week`, `:month`, or `:all`
		# @option params [Integer] :count (20) Number of images to return between 0 and 50
		# @option params [Integer] :page (1) Which page of images to display
		# @return [Hash] Set of image information
		def gallery params = {}
			options = { :query => { :key => @api_key } }
			options[:query].merge!(params)
			response = self.class.get('/gallery.json', options)
			if response.key?(:error)
				throw ImgurError.new(response[:error][:error_msg])
			else
				response[:images]
			end
		end

		# Returns statistics for a specific image, like size, type, and bandwidth usage
		#
		# @param [String] image_hash Imgur's hash of the image
		# @return [Hash] Image statistics
		def image_stats image_hash
			options = { :query => { :key => @api_key } }
			response = self.class.get("/stats/#{image_hash}.json", options)
			response[:rsp]
		end

		# Deletes the image with the specified hash
		#
		# @param [String] image_hash Imgur's hash of the image
		# @return [Boolean] Whether or not the image was deleted 
		def delete image_hash
			options = { :query => { :key => @api_key } }
			response = self.class.get("/delete/#{image_hash}.json", options)
			response[:rsp][:stat] == "ok"
		end

	end
	
end
