class DeviceType < ApplicationRecord
    has_many :devices
    validates :device_type, uniqueness: true ,presence: true
end
