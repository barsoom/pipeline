class Api::GithubActionsWebhooksController < ApiController
  protect_from_forgery prepend: true

  def create
    workflow_job = params[:workflow_job]

    unless workflow_job
      render json: {}
      return
    end

    unless workflow_job[:head_branch] == params[:repository][:default_branch]
      render json: {}
      return
    end

    project = UpdateBuildStatus.call(
      workflow_job[:name],
      params[:repository][:ssh_url],
      workflow_job[:head_sha],
      convert_gha_status_to_pipeline_status(workflow_job[:status], workflow_job[:conclusion]),
      workflow_job[:html_url],
    )

    ActionCable.server.broadcast("projects", {
      project_id: project.id,
      html: render_to_string(
        partial: "projects/project",
        locals: { project:, revision_count: ::ProjectsController::MAX_REVISIONS },
      ),
    })

    PostStatusToWebhook.call(project)

    render json: {}
  end

  private

  def convert_gha_status_to_pipeline_status(status, conclusion)
    # conclusion can be one of: success, failure, nil
    # status can be one of: completed, action_required, cancelled, failure, neutral, skipped, stale, success, timed_out, in_progress, queued, requested, waiting, pending

    return "successful" if conclusion == "success"
    return "failed" if conclusion == "failure"

    return "building" if status == "in_progress"
    return "pending" if status == "queued"

    "pending"
  end

  def check_token
    signature = "sha256=" + OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new("sha256"), ENV["GITHUB_WEBHOOK_SECRET"], request.body.read)
    return if Rack::Utils.secure_compare(signature, request.headers["X-Hub-Signature-256"])

    render body: nil, status: :unauthorized
  end
end
