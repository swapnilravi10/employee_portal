class Empleave < ApplicationRecord
  belongs_to :requestee, class_name: 'User'
  belongs_to :attendee, class_name: 'User'


  after_validation :past_leave_approve, on: [ :create, :update ]

  def past_leave_approve
    if self.start_time < Date.today
      self.approved = true
      self.approval_date = self.start_time
    end
  end
end
