class User < ApplicationRecord
	has_secure_password

	validates :email, presence: true, uniqueness: true, format: { with: /\A[^@\s]+@([^@.\s]+\.)+[^@.\s]+\z/ }
	
	has_many :notes

	has_many :user_shares
	has_many :roles, through: :user_shares

	def get_contribution note_id
		
		role_id = Role.find_by(name: 'contributor').id
		user_share = self.user_shares.find_by(role_id: role_id, note_id: note_id)
		
		unless user_share.nil?
			return {is_contributor: true, is_reader: true}
		end

		role_id = Role.find_by(name: 'reader').id
		user_share = self.user_shares.find_by(role_id: role_id, note_id: note_id)
		
		unless user_share.nil?
			return {is_contributor: false, is_reader: true}
		end		

		return {is_contributor: false, is_reader: false}
	end
end