class Notification < ApplicationRecord
  before_create :default_values

  def default_values
    self.archived ||= 0
    self.is_read ||= 0
  end

  belongs_to :user
  belongs_to :group, optional: true
  belongs_to :social_post, optional: true

  enum notification_type: [:comment, :like, :transfer, :report, :invite, :group_request, :new_pet_health_record, :reminder]
end
