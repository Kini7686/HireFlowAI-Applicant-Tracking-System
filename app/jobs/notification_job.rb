class NotificationJob < ApplicationJob
  queue_as :default

  def perform(user_id, title, message, notification_type)
    Notification.create!(
      user_id: user_id,
      title: title,
      message: message,
      notification_type: notification_type
    )
  end
end
