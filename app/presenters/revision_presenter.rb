require "build_presenter"

class RevisionPresenter
  pattr_initialize :revision

  def name
    revision.name[0, 5]
  end

  def builds
    BuildPresenter.new(revision).list
  end

  def all_builds_successful?
    builds.map(&:status).uniq == [ BuildStatus::SUCCESSFUL ]
  end

  def total_time_in_words
    total_seconds = revision.seconds_from_creation_to_last_build_update
    minutes = (total_seconds / 60).to_i
    seconds = (total_seconds - minutes * 60).to_i

    [ minutes, "min", seconds, "sec" ].join(" ")
  end

  def created_at
    revision.created_at.localtime.strftime("(%T %F %Z)")
  end
end
