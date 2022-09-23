class ProjectChannel < ApplicationCable::Channel
  def subscribed
    stream_from "projects"
  end
end
