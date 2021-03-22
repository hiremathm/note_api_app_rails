require 'json_web_token'
class AuthorizeApiRequest
	prepend SimpleCommand

	def initialize(headers = {})
		@headers = headers
	end

	def call
		user
	end

	private

	attr_reader :headers

	def user
		@user ||= User.find(decode_auth_token[:user_id]) if decode_auth_token
		@user || errors.add(:token, 'Invalid Token') && nil 
	end

	def decode_auth_token
		token = get_token
		Rails.logger.info "GOTTOKEN1 #{token}"
		token = JsonWebToken.decode(token)
		Rails.logger.info "GOTTOKEN2 #{token}"
		if token.present?
			@decode_auth_token = token
		else
			@decode_auth_token = false
		end
		# @decode_auth_token ||= JsonWebToken.decode(get_token)
	end

	def get_token
		Rails.logger.info "HEADERS #{headers["HTTP_X_AUTH"]}"
		if headers["HTTP_X_AUTH"].present?
			Rails.logger.info "AUTH PRESENT"
			return headers["HTTP_X_AUTH"]
		else
			errors.add(:token, 'Invalid Authorization')
		end

		nil
	end
end


# https://www.pluralsight.com/guides/token-based-authentication-with-ruby-on-rails-5-api