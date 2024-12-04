class CloudInitsController < WebController
  def index
    locals cloud_inits: CloudInit.all
  end

  def new
    locals cloud_init: CloudInit.new
  end

  def edit
    locals cloud_init: CloudInit.find(params[:id])
  end

  def create
    cloud_init = CloudInit.new(cloud_init_params)

    if cloud_init.save
      redirect_to cloud_inits_path, notice: "Cloud-init was successfully created."
    else
      render :new, locals: { cloud_init: }, status: :unprocessable_entity
    end
  end

  def update
    cloud_init = CloudInit.find(params[:id])

    if cloud_init.update(cloud_init_params)
      redirect_to cloud_inits_path, notice: "Cloud-init was successfully updated."
    else
      render :edit, locals: { cloud_init: }, status: :unprocessable_entity
    end
  end

  def destroy
    cloud_init = CloudInit.find(params[:id])
    cloud_init.destroy!
    redirect_to cloud_inits_path, notice: "Cloud-init was successfully destroyed.", status: :see_other
  end

  private

  def setup_menu
    active_menu_item_name :cloud_inits
  end

  def cloud_init_params
    params.require(:cloud_init).permit(:name, :data)
  end
end
