# == Schema Information
#
# Table name: cloud_inits
#
#  config        :jsonb            not null
#  created_at    :datetime         not null
#  id            :bigint           not null, primary key
#  name          :string           not null
#  password_salt :string           not null
#  template      :text             not null
#  updated_at    :datetime         not null
#
class CloudInit < ActiveRecord::Base
  has_paper_trail

  validates :name, :template, presence: true

  before_validation :generate_password_salt, on: :create

  def generate_password_salt
    self.password_salt = SecureRandom.hex(32)
  end
end
