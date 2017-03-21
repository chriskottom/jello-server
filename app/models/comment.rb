class Comment < ApplicationRecord
  belongs_to :card
  belongs_to :creator, class_name: 'User'

  validates :body, presence: true
end
