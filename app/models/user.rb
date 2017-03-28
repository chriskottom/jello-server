class User < ApplicationRecord
  include Gravatar

  has_secure_password

  paginates_per 10

  has_many :boards, foreign_key: 'creator_id', dependent: :nullify
  has_many :lists, foreign_key: 'creator_id', dependent: :nullify
  has_many :cards, foreign_key: 'creator_id', dependent: :nullify
  has_many :comments, foreign_key: 'creator_id', dependent: :nullify
  has_many :assigned_cards, dependent: :nullify,
           class_name: 'Card', foreign_key: 'assignee_id'

  validates :email, presence: true, uniqueness: true

  default_scope { order(:created_at) }

  def self.admin
    where(admin: true)
  end
end
