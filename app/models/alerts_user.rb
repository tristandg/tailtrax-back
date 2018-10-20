class AlertsUser < ApplicationRecord
    belongs_to :alerts, :class_name => 'Alert', foreign_key: "alert_id"
    belongs_to :users, :class_name => 'User', foreign_key: "receiver_user_id"

end
