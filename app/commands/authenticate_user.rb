require 'json_web_token'
class AuthenticateUser
	prepend SimpleCommand

	def initialize(email, password)
		@email = email
		@password = password
	end

	def call
		JsonWebToken.encode(user_id: user.id, email: user.email) if user
	end

	private 
	attr_accessor :email, :password
	
	def user
		user = User.find_by_email(email)
		return user if user && user.authenticate(password)
		errors.add :user_authentication, 'Invalid Credentials!!!'
		nil
	end
end