# == Schema Information
#
# Table name: builds
#
#  created_at  :datetime         not null
#  id          :bigint           not null, primary key
#  name        :string           not null
#  revision_id :integer
#  status      :string           not null
#  status_url  :string
#  updated_at  :datetime         not null
#
# Indexes
#
#  idx_builds_revision_id       (revision_id)
#  idx_builds_revision_name_id  (revision_id,name,id)
#
class Build < ActiveRecord::Base
  validates :name, :status, presence: true

  belongs_to :revision
end
