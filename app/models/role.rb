class Role < ApplicationRecord
	has_many :user_shares
	has_many :users, through: :user_shares
end
