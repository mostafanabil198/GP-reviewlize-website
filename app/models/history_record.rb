class HistoryRecord < ApplicationRecord
  belongs_to :user
  has_many :history_products, dependent: :destroy
end
