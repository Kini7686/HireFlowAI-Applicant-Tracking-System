class Notification < ApplicationRecord
  include Turbo::Broadcastable
  belongs_to :user

  scope :unread, -> { where(read_at: nil) }
  scope :recent, -> { order(created_at: :desc) }

  after_create_commit :broadcast_notification

  def read?
    read_at.present?
  end

  def mark_as_read!
    update!(read_at: Time.current)
  end

  private

  def broadcast_notification
    broadcast_prepend_to(
      "notifications_#{user_id}",
      target: "notifications_list",
      partial: "notifications/notification",
      locals: { notification: self }
    )
    broadcast_update_to(
      "notifications_#{user_id}",
      target: "notification_badge",
      partial: "notifications/badge",
      locals: { count: user.notifications.unread.count }
    )
  end
end
