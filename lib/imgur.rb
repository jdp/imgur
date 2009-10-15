require 'curb'
require 'crack/json'
require 'cgi'

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

	# Imgur API interface
	class API

		# Creates a new Imgur API instance
		#
		# @param [String] api_key Your API key from http://imgur.com/register/api/
		# @return [API] An Imgur API instance
		def initialize api_key
			@api_key = api_key
		end

		# Uploads an image from local disk
		#
		# @param [String] image_filename The filename of the image on disk to upload
		# @raise [ImgurError]
		# @return [Hash] Image data
		def upload_file image_filename
			c = Curl::Easy.new("http://imgur.com/api/upload.json")
			c.multipart_form_post = true
			c.http_post(Curl::PostField.content('key', @api_key), Curl::PostField.file('image', image_filename))
			response = Crack::JSON.parse c.body_str
			raise ImgurError, response["rsp"]["error_msg"] if response["rsp"]["stat"] == "fail"
			response["rsp"]["image"]
		end
		
		# Uploads a file from a remote URL
		#
		# @param [String] image_url The URL of the image to upload
		# @raise [ImgurError]
		# @return [Hash] Image data
		def upload_from_url image_url
			c = Curl::Easy.new("http://imgur.com/api/upload.json")
			c.http_post(Curl::PostField.content('key', @api_key), Curl::PostField.content('image', image_url))
			response = Crack::JSON.parse c.body_str
			raise ImgurError, response["rsp"]["error_msg"] if response["rsp"]["stat"] == "fail"
			response["rsp"]["image"]
		end

		# Returns a set of images in gallery format based on your specifications
		#
		# @param [Hash] params Query string parameters to pass
		# @option params [String] :sort Sort order, values are `:latest` or `:popular`
		# @option params [String] :view Date limit, values are `:week`, `:month`, or `:all`
		# @option params [Integer] :count (20) Number of images to return between 0 and 50
		# @option params [Integer] :page (1) Which page of images to display
		# @raise [ImgurError]
		# @return [Array<Hash>] Array of image data hashes
		def gallery params = {}
			post_fields = params.collect { |k, v| CGI::escape(k.to_s) + '=' + CGI::escape(v.to_s) }.join('&')
			c = Curl::Easy.new("http://imgur.com/api/gallery.json?#{post_fields}")
			c.http_get
			response = Crack::JSON.parse c.body_str
			raise ImgurError, response["error"]["error_msg"] if response.key?("error")
			response["images"].to_a.collect { |hash, info| info }
		end

		# Returns statistics for a specific image, like size, type, and bandwidth usage
		#
		# @param [String] image_hash Imgur's hash of the image
		# @raise [ImgurError]
		# @return [Hash] Image statistics
		def image_stats image_hash
			c = Curl::Easy.new("http://imgur.com/api/stats/#{image_hash}.json")
			c.http_get
			response = Crack::JSON.parse c.body_str
			raise ImgurError, response["error"]["error_msg"] if response.key?("error")
			response["stats"]
		end

		# Deletes the image with the specified delete hash.
		# Delete hashes are not the same as image hashes, they are two separate hashes.
		#
		# @param [String] delete_hash Imgur's delete hash of the image
		# @return [Boolean] Whether or not the image was deleted 
		def delete image_hash
			c = Curl::Easy.new("http://imgur.com/api/delete/#{image_hash}.json?key=#{@api_key}")
			c.http_get
			response = Crack::JSON.parse c.body_str
			response["rsp"]["stat"] == "ok"
		end

	end
	
end
