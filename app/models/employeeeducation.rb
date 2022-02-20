class Employeeeducation < ApplicationRecord
    belongs_to :user
    validates :year_of_passing, :numericality => {:only_integer => true}
end
