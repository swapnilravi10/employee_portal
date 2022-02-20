class Status < ApplicationRecord
    has_one :user, through: :userstatus    
end
