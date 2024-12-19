class Api::CloudInitsController < ApiController
  def show
    cloud_init = CloudInit.find_by!(name: params[:name])

    helper = CloudInitTemplateHelper.new(cloud_init:, remote_ip: request.remote_ip)

    # We don't run any code in the template itself since we don't need to
    # and it removes one possible attack vector.
    data = cloud_init.template.gsub(/{{(.*?)}}/) {
      variable = $1

      if [ :password ].include?(variable.to_sym)
        helper.public_send(variable)
      elsif [ :remote_ip ].include?(variable.to_sym)
        request.remote_ip
      else
        helper.config(variable)
      end
    }

    render plain: data, content_type: "text/cloud-config"
  end
end
