class User < ApplicationRecord
  has_secure_password

  EMAIL_REGEX = /\A[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}\z/
  PASSWORD_REGEX = /\A(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]+\z/

  validates :email, presence: true, uniqueness: true,
                    format: {
                      with: EMAIL_REGEX,
                      message: I18n.t('activerecord.errors.models.user.attributes.email.invalid')
                    }

  validates :password, length: {
                          minimum: 8,
                          message: I18n.t('activerecord.errors.models.user.attributes.password.too_short', count: 8)
                        },
                       format: {
                          with: PASSWORD_REGEX,
                          message: I18n.t('activerecord.errors.models.user.attributes.password.invalid')
                        }, if: -> { password.present? }
end
