class Technology < ApplicationRecord
    validates :name, presence: true, uniqueness: true
    has_many :usertechnologies, dependent: :destroy 
end
