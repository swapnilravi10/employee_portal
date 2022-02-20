class Device < ApplicationRecord
    belongs_to :user, optional: true
    belongs_to :device_type, optional: true
end
