class AuthenticationController < ApplicationController
	before_action :authenticate_request, except: [:signin, :signup]

	def signin

		command = AuthenticateUser.call(params[:email], params[:password])
		if command.success?
			render json: {status: "success", token: command.result}, status: 200
		else
			render json: {status: "failed", error: {message: "Invalid Email or Password"}}, status: 401
		end
	end

	def signup
		user = User.create(authenticate_params)
		if user.valid?
			render json: {status: "success"}, status: 200
		else
			render json: {status: "failed", error: user.errors.messages}, status: 422
		end
	end

	def show
		if @current_user
			render json: {status: "success", user: @current_user.slice(:id, :email, :created_at)}, status: 200
		else
			render json: {status: "failed", error: {message: "Invalid Auth Token"}}, status: 401
		end
	end

	def index
		if @current_user
			render json: {status: "success", users: User.all}, status: 200
		else
			render json: {status: "failed", error: {message: "Invalid Auth Token"}}, status: 401
		end
	end

	def get_roles
		if @current_user
			render json: {status: "success", roles: Role.all}, status: 200
		else
			render json: {status: "failed", error: {message: "Invalid Auth Token"}}, status: 401
		end
	end

	private

	def authenticate_params
		params.require(:authentication).permit(:email, :password)
	end
end