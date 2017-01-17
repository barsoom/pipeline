class ProjectsController < WebController
  before_action :get_projects

  MAX_REVISIONS = 15

  def index
    revision_count = 2
    locals revision_count: revision_count
  end

  def show
    project = Project.find(params[:id])
    revision_count = MAX_REVISIONS
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

    # Simple workaround to remove projects from our dashboard when they are renamed.
    # Name is used as a unique identifier since we don't pass id using the webhook.
    if project.name_changed?
      project_to_remove_in_remote_app = Project.find(project.id)
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
    Project.find(params[:id]).destroy
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
