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
		@decode_auth_token ||= JsonWebToken.decode(get_token)
	end

	def get_token
		Rails.logger.info "HEADERS #{headers.inspect}"
		if headers['X-Auth'].present?
			return headers['X-Auth'].split(' ').last
		else
			errors.add(:token, 'Invalid Authorization')
		end

		nil
	end
end


# https://www.pluralsight.com/guides/token-based-authentication-with-ruby-on-rails-5-api