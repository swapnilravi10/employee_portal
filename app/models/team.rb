class Team < ApplicationRecord
    has_many :team_member, dependent: :destroy
    has_many :projects, dependent: :destroy
    validates_presence_of :name
end
