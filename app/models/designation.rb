class Designation < ApplicationRecord
    validates :name, presence: true, uniqueness: true
    has_many :users

    def get_designation_name
        "#{name.to_s.split('_').join(' ').titleize}"
    end
end
