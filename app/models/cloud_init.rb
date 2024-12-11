class CloudInit < ActiveRecord::Base
  validates :name, :template, presence: true

  before_validation :generate_password_salt, on: :create

  def generate_password_salt
    self.password_salt = SecureRandom.hex(32)
  end
end
