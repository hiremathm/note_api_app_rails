class JsonWebToken
	class << self
		def encode(payload, exp = 24.hours.from_now)
			payload[:exp] = exp.to_i
			if ENV["RAILS_ENV"] == "development"
				JWT.encode(payload, Rails.application.secrets.secret_key_base)
			else
				JWT.encode(payload, ENV["SECRET_KEY_BASE"])
			end
		end

		def decode(token)
			begin
				if ENV["RAILS_ENV"] == "development"
					body = JWT.decode(token, Rails.application.secrets.secret_key_base)[0]
				else
					body = JWT.decode(token, ENV["SECRET_KEY_BASE"])[0]
				end
				Rails.logger.info "BODY #{body.inspect}"
				return HashWithIndifferentAccess.new body
				
			rescue Exception => e
				Rails.logger.info "Exception #{e.message}"
				return nil
			end
		end
	end
end