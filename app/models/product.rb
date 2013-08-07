class Product < ActiveRecord::Base
  has_many :records, dependent: :destroy

  validates :asin, :uniqueness => true
end
