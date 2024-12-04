class CloudInit < ActiveRecord::Base
  validates :name, :data, presence: true
end
