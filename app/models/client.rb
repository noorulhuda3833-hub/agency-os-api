class Client < ApplicationRecord
  belongs_to :workspace
  belongs_to :company

  has_many :notes, dependent: :destroy

  validates :name, presence: true

  validates :email,
            presence: true,
            format: {
              with: URI::MailTo::EMAIL_REGEXP,
              message: "is invalid"
            }

  validates :phone,
            presence: true,
            format: {
              with: /\A\d{11}\z/,
              message: "must be exactly 11 digits"
            }

  validates :company, presence: true
end