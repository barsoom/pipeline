class Api::BuildStatusesController < ApiController
  protect_from_forgery prepend: true

  def create
    project = UpdateBuildStatus.call(
      params[:name],
      params[:repository],
      params[:revision],
      params[:status],
      params[:status_url],
    )

    ActionCable.server.broadcast("projects", {
      project_id: project.id,
      html: render_to_string(
        partial: "projects/project",
        locals: { project:, revision_count: ::ProjectsController::MAX_REVISIONS }
      )
    })

    PostStatusToWebhook.call(project)

    render body: nil
  end
end
