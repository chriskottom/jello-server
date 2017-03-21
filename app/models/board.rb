class Board < ApplicationRecord
  belongs_to :creator, class_name: 'User'
  has_many :lists, dependent: :destroy

  validates :title, presence: true
end
