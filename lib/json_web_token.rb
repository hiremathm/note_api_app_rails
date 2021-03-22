class JsonWebToken
	class << self
		def encode(payload, exp = 24.hours.from_now)
			payload[:exp] = exp.to_i
			JWT.encode(payload, Rails.application.secrets.secret_key_base)
		end

		def decode(token)
			begin
				body = JWT.decode(token, Rails.application.secrets.secret_key_base)[0]
				Rails.logger.info "BODYIS #{body.inspect}"
				return HashWithIndifferentAccess.new body
			rescue Exception => e
				Rails.logger.info "Exception #{e.message}"
				return nil
			end
		end
	end
end