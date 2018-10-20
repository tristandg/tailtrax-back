class Alert < ApplicationRecord
  has_and_belongs_to_many :users, join_table: "alerts_users", foreign_key: "alert_id", association_foreign_key: "receiver_user_id"
  #has_many :alerts_user
  belongs_to :user, foreign_key: "sender_user_id"

end
