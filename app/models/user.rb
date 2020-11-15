class User < ApplicationRecord
  # パスワード
  has_secure_password
  validates :name, presence: true
  validates :email,presence: true,uniqueness:true
end
