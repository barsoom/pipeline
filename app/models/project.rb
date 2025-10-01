# == Schema Information
#
# Table name: projects
#
#  created_at :datetime         not null
#  id         :bigint           not null, primary key
#  mappings   :text
#  name       :string           not null
#  position   :integer          default(0)
#  repository :string
#  updated_at :datetime         not null
#
class Project < ActiveRecord::Base
  has_many :revisions, dependent: :destroy
  after_initialize :set_name

  validates :name, presence: true

  def self.all_sorted
    left_joins(:revisions)
      .group(:id)
      .order(Arel.sql("projects.position ASC, COALESCE(MAX(revisions.created_at), '1970-01-01') DESC, projects.name ASC"))
  end

  def self.find_or_create_for_repository(repository)
    where(repository:).first_or_create!
  end

  def latest_revisions(limit = 10)
    revisions.order("id desc").limit(limit)
  end

  def github_url
    github_path = repository.to_s[/github\.com:(.*?)\./, 1]
    return nil unless github_path

    "https://github.com/#{github_path}"
  end

  private

  def set_name
    return unless repository

    self.name ||= repository.split("/").last.split(".").first
  end
end
