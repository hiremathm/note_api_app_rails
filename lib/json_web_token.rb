class JsonWebToken
	class << self
		def encode(payload, exp = 24.hours.from_now)
			payload[:exp] = exp.to_i
			JWT.encode(payload, Rails.application.secrets.secret_key_base)
		end

		def decode(token)
			Rails.logger.info "SECRET_KEY_BASE #{Rails.application.secrets.secret_key_base}"
			begin
				body = JWT.decode(token, Rails.application.secrets.secret_key_base)
				Rails.logger.info "BODYIS #{body.inspect}"
				return HashWithIndifferentAccess.new body
			rescue Exception => e
				Rails.logger.info "Exception #{e.message}"
				return nil
			end
		end
	end
end