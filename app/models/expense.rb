class Expense < ApplicationRecord
  belongs_to :user
  belongs_to :category

  enum visibility: [ :private, :public ]

  validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :description, presence: true, length: { maximum: 255 }
  validates :user, presence: true
  validates :category, presence: true
end
