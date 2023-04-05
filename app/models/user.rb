class User < ApplicationRecord
  has_many :viewing_party_users
  has_many :viewing_parties, through: :viewing_party_users

  validates_presence_of :name, :email, :password_digest
  validates_uniqueness_of :email

  has_secure_password

  enum role: ["default", "admin"]

  scope :default_users, -> { where(role: "default") }
end