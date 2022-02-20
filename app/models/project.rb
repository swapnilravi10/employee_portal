class Project < ApplicationRecord
    belongs_to :user, foreign_key: "project_leader_id" 
    belongs_to :client, optional: true
    validates :name, :presence => true, :uniqueness => true
    has_many :project_teams, dependent: :destroy

    def get_user id
        return User.find_by(id: id)
    end
end
