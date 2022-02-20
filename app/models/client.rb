class Client < ApplicationRecord
    has_many :projects, dependent: :destroy
    validates_presence_of :last_name
    validates_presence_of :company_name
    validates :email, uniqueness: true

    def client_full_name
        if first_name.blank?
            "#{last_name}"
        else
            "#{first_name} #{last_name}"
        end
    end

end