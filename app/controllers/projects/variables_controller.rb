class Projects::VariablesController < Projects::ApplicationController
  before_action :variable, only: [:show, :update, :destroy]
  before_action :authorize_admin_build!

  layout 'project_settings'

  def index
    redirect_to project_settings_ci_cd_path(@project)
  end

  def show
  end

  def update
    if variable.update(variable_params)
      redirect_to project_variables_path(project),
                  notice: '变量更新成功。'
    else
      render "show"
    end
  end

  def create
    @variable = project.variables.create(variable_params)
      .present(current_user: current_user)

    if @variable.persisted?
      redirect_to project_settings_ci_cd_path(project),
                  notice: '变量创建成功。'
    else
      render "show"
    end
  end

  def destroy
    if variable.destroy
      redirect_to project_settings_ci_cd_path(project),
                  status: 302,
                  notice: '变量删除成功。'
    else
      redirect_to project_settings_ci_cd_path(project),
                  status: 302,
                  notice: '变量删除失败。'
    end
  end

  private

  def variable_params
    params.require(:variable).permit(*variable_params_attributes)
  end

  def variable_params_attributes
    %i[id key value protected _destroy]
  end

  def variable
    @variable ||= project.variables.find(params[:id]).present(current_user: current_user)
  end
end
