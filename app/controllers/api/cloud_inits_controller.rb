class Api::CloudInitsController < ApiController
  def show
    template = CloudInit.find_by!(name: params[:name]).data

    helper = CloudInitTemplateHelper.new(request.remote_ip)

    # We don't run any code in the template itself since we don't need to
    # and it removes one possible attack vector.
    data = template.gsub(/{{(.*?)}}/) {
      variable = $1

      if helper.public_methods.include?(variable.to_sym)
        helper.public_send(variable)
      else
        helper.config(variable)
      end
    }

    render plain: data, content_type: "text/cloud-config"
  end
end
