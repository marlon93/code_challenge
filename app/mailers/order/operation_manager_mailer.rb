class Order
  class OperationManagerMailer < ApplicationMailer
    MANAGER_EMAIL = ENV['MANAGER_EMAIL']

    default from: 'notifications@mancrates.com'

    def send_email
      return unless MANAGER_EMAIL.present?

      mail(to: MANAGER_EMAIL, subject: 'The order batch shipping has been successfully updated.')
    end
  end
end
