class Client < ApplicationRecord
  has_many :quotes, dependent: :restrict_with_error

  normalizes :email, with: ->(email) { email.strip.downcase }

  validates :name, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  def display_name
    company.present? ? "#{name}, #{company}" : name
  end
end
