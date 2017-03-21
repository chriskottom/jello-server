class Card < ApplicationRecord
  belongs_to :list
  belongs_to :creator, class_name: 'User'
  belongs_to :assignee, class_name: 'User', optional: true
  has_many :comments, dependent: :destroy

  validates :title, presence: true
end
