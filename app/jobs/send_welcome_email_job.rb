class SendWelcomeEmailJob < ApplicationJob
  queue_as :default

  def perform(user)
    # Do something later
    UserMailer.welcome_email(user).deliver_now
  end
end
