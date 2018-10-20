class Conversation < ApplicationRecord
  before_create :set_defaults

  def set_defaults
    self.guid ||= SecureRandom.uuid
  end

  has_many :direct_messages
  has_and_belongs_to_many :users
end
