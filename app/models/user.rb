
class User < ApplicationRecord
    include Hashid::Rails
    has_many :team_members, dependent: :destroy
    # has_many :empleaves, :class_name => "Empleave", dependent: :destroy
    has_many :requestee_empleaves, class_name: 'Empleave', foreign_key: 'requestee_id'
    has_many :attendee_empleaves, class_name: 'Empleave', foreign_key: 'attendee_id'
    has_one :payroll,dependent: :destroy
    has_one :bankdetail, dependent: :destroy
    has_one :employeeeducation, dependent: :destroy
    has_one :workexperience, dependent: :destroy
    has_many :assignments, dependent: :destroy
    has_many :attendances, dependent: :destroy
    has_many :roles, through: :assignments  
    has_one :userstatus
    has_one :status, through: :userstatus
    has_one :project_leader_projects, class_name: 'Project', foreign_key: 'project_leader_id'
    has_many :usertechnologies, dependent: :destroy
    has_one_attached :avatar
    has_many :project_teams, dependent: :destroy
    USER_TYPES = ["Admin", "Employee"]
    has_secure_password
    validates :first_name, presence: true
    validates :last_name, presence: true
    validates :email, uniqueness: true #format: { with: /\b[A-Z0-9._%a-z\-]+@gmail\.com\z/, message: "must be a gmail.com account" }
    validates :adhar_card_number, presence: true
    validates :date_of_joining, presence: true
    validates :password, length: {in: 6..12}, :on => :create
    validates_length_of :phone_number, is: 10
    validates_length_of :emergency_contact_number, is: 10
    validates :password, confirmation: { case_sensitive: true }
    has_many :posts
    has_many :comments
    has_many :devices
    belongs_to :designation
    def full_name
        "#{first_name} #{last_name}"
    end

    def full_email_name
        "#{email} - #{first_name} #{last_name}"
    end

    def role?(role)  
        roles.any? { |r| r.name.underscore.to_sym == role }  
    end

    def empleave_access
        viewer_ids = []
        tmembers = self.team_members
        tmembers.each do |tm|
            new_project_manager = Team.find_by(:id => tm.team_id).project_manager_id
            if !new_project_manager.blank?
                viewer_ids.push(new_project_manager)
                project_manager = new_project_manager
                for m in viewer_ids
                    team_members = User.find(project_manager).team_members
                    pm_teams  = team_members.map{|tm| tm.team_id}
                    pms_for_pm = pm_teams.map{|tid| Team.find(tid).project_manager_id}
                    for pgm in pms_for_pm
                        if pgm.blank? or pgm ==  project_manager or viewer_ids.include? pgm
                            next
                        else
                            viewer_ids.push(pgm)
                            project_manager = pgm
                        end
                    end
                end
            end
        end
        viewer_ids
    end

    def leave_followup
        leave_details = {}
        leave_details['allowed_leaves'] = 21
        leave_details['total_leaves'] = Empleave.where(:requestee_id => self.id , :approved => true, :half_day=> true).count.to_f/2 + Empleave.where(:requestee_id => self.id , :approved => true, :half_day=> false).count.to_f
        this_year_leaves = Empleave.where('extract(year  from start_time) = ?',DateTime.now.year)
        this_year_half = this_year_leaves.where(:requestee_id => self.id ,:approved => true , :half_day => true).count
        this_year_full = this_year_leaves.where(:requestee_id => self.id ,:approved => true , :half_day => false).count
        leave_details['current_year_leaves'] = this_year_full.to_f + (this_year_half.to_f/2)
        leave_details['current_year_remaining_leaves'] = 21 - leave_details['current_year_leaves']
        leave_details
    end
end