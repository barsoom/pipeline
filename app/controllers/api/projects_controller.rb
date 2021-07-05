class Api::ProjectsController < ApiController
  def destroy
    project = Project.find_by_name(params[:name])
    project.destroy!

    PostStatusToWebhook.call(project)

    render body: nil, text: "ok"
  end
end
