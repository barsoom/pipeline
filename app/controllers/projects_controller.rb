class ProjectsController < WebController
  before_action :get_projects

  # Keep this number low. We push updates that include revision data every time a change comes in.
  # We've seen timeouts when this was set to 50.
  MAX_REVISIONS = 15

  def index
    revision_count = 2
    locals revision_count: revision_count
  end

  def show
    project = Project.find(params[:id])
    revision_count = params[:revision_count] || MAX_REVISIONS
    locals :show,
      revision_count: revision_count,
      project: project
  end

  def edit
    @project = Project.find(params[:id])
  end

  def update
    project = Project.find(params[:id])

    project.attributes = project_params

    # Simple workaround to avoid duplicate projects in apps using the webhook by
    # first removing the old one and then adding a new one when renaming a project.
    #
    # We have to do this because the project name is the unique identifier.
    if project.name_changed?
      # We need a record with the old name, since that will be used as the unique identifier
      project_to_remove_in_remote_app = Project.find(project.id)

      # The "destroyed?" value tells the webhook that we want to remove the project
      project_to_remove_in_remote_app.define_singleton_method(:destroyed?) { true }

      PostStatusToWebhook.call(project_to_remove_in_remote_app)
    end

    if project.save
      PostStatusToWebhook.call(project)
      redirect_to root_path, notice: "Project updated."
    else
      @project = project
      render :edit
    end
  end

  def destroy
    project = Project.find(params[:id])

    project.destroy!
    PostStatusToWebhook.call(project)

    redirect_to root_path, notice: "Project removed."
  end

  private

  def project_params
    params.require(:project).permit(:name, :repository, :mappings, :position)
  end

  def setup_menu
    active_menu_item_name :projects
  end

  def get_projects
    @projects = Project.all_sorted
  end
end
