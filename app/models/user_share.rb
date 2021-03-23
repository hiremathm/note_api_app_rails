class UserShare < ApplicationRecord
	belongs_to :user
	belongs_to :role

	def get_role_details
		role = Role.find_by(id: self.role_id)
		user = User.find_by(id: self.user_id)
		return {role_name: role.name, user_email: user.email}
	end
end