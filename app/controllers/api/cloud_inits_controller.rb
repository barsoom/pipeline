class Api::CloudInitsController < ApiController
  def show
    data = CloudInit.find_by!(name: params[:name]).data
    render plain: data, content_type: "text/cloud-config"
  end
end
