class Exchange < ActiveRecord::Base
  attr_accessible :country, :name
  has_many :securities

  validates :name, presence: true
end
