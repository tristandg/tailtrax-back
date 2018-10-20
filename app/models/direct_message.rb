class DirectMessage < ApplicationRecord
  belongs_to :conversation
  belongs_to :user

  enum media_type: [:image, :video]

end
