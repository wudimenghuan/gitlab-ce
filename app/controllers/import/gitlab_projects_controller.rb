class Import::GitlabProjectsController < Import::BaseController
  before_action :verify_gitlab_project_import_enabled

  def new
    @namespace = Namespace.find(project_params[:namespace_id])
    return render_404 unless current_user.can?(:create_projects, @namespace)
    @path = project_params[:path]
  end

  def create
    unless file_is_valid?
      return redirect_back_or_default(options: { alert: "您需要上传 GitLab 项目导出存档。" })
    end

    import_upload_path = Gitlab::ImportExport.import_upload_path(filename: project_params[:file].original_filename)

    FileUtils.mkdir_p(File.dirname(import_upload_path))
    FileUtils.copy_entry(project_params[:file].path, import_upload_path)

    @project = Gitlab::ImportExport::ProjectCreator.new(project_params[:namespace_id],
                                                        current_user,
                                                        import_upload_path,
                                                        project_params[:path]).execute

    if @project.saved?
      redirect_to(
        project_path(@project),
        notice: "正在导入项目 '#{@project.name}' 。"
      )
    else
      redirect_back_or_default(options: { alert: "项目无法被导入： #{@project.errors.full_messages.join(', ')}" })
    end
  end

  private

  def file_is_valid?
    project_params[:file] && project_params[:file].respond_to?(:read)
  end

  def verify_gitlab_project_import_enabled
    render_404 unless gitlab_project_import_enabled?
  end

  def project_params
    params.permit(
      :path, :namespace_id, :file
    )
  end
end
