require 'httparty'
require 'pp'

# @author Justin Poliey
# Imgur module
module Imgur

	# General Imgur error container
	class ImgurError < RuntimeError
		
		def initialize message
			@message = message
			super
		end
		
	end
	
	# Image data container
	class Image
	
		attr_accessor :image_hash, :delete_hash
		attr_accessor :original_image
		attr_accessor :large_thumbnail, :small_thumbnail
		attr_accessor :imgur_page, :delete_page
		
		def initialize image_info
			image_hash = image_info["image_hash"]
			delete_hash = image_info["delete_hash"]
			original_image = image_info["original_image"]
			large_thumbnail = image_info["large_thumbnail"]
			small_thumbnail = image_info["small_thumbnail"]
			imgur_page = image_info["imgur_page"]
			delete_page = image_info["delete_page"]
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
		# @return [API] An Imgur API instance
		def initialize api_key
			@api_key = api_key
		end

		# Uploads an image from local disk, a Base64 encoded string, or a URL
		#
		# @param [String] image The image data. If uploading from local disk, prefix the filename with an @
		# @return [Image] Image data
		def upload image
			options = { :query => { :key => @api_key, :image => image } }
			response = self.class.post('/upload.json', options)
			#raise ImgurError, response["rsp"]["error_msg"] if response["rsp"]["stat"] == "fail"
			puts response
			#Image.new(response["rsp"]["image"])
			response
		end

		# Returns a set of images in gallery format based on your specifications
		#
		# @param [Hash] params Query string parameters to pass
		# @option params [String] :sort Sort order, values are `:latest` or `:popular`
		# @option params [String] :view Date limit, values are `:week`, `:month`, or `:all`
		# @option params [Integer] :count (20) Number of images to return between 0 and 50
		# @option params [Integer] :page (1) Which page of images to display
		# @return [Array<Image>] Array of image data objects
		def gallery params = {}
			options = { :query => { :key => @api_key } }
			options[:query].merge!(params)
			response = self.class.get('/gallery.json', options)
			raise ImgurError, response["error"]["error_msg"] if response.key?("error")
			response["images"].to_a.collect { |hash, info| Image.new(info) }
		end

		# Returns statistics for a specific image, like size, type, and bandwidth usage
		#
		# @param [String] image_hash Imgur's hash of the image
		# @return [Hash] Image statistics
		def image_stats image_hash
			options = { :query => { :key => @api_key } }
			response = self.class.get("/stats/#{image_hash}.json", options)
			raise ImgurError, response["error"]["error_msg"] if response.key?("error")
			response["stats"]
		end

		# Deletes the image with the specified delete hash.
		# Delete hashes are not the same as image hashes, they are two separate hashes.
		#
		# @param [String] delete_hash Imgur's delete hash of the image
		# @return [Boolean] Whether or not the image was deleted 
		def delete image_hash
			options = { :query => { :key => @api_key } }
			response = self.class.get("/delete/#{image_hash}.json", options)
			raise ImgurError, response["rsp"]["error_msg"] if response["rsp"]["stat"] == "fail"
			response["rsp"]["stat"] == "ok"
		end

	end
	
end
