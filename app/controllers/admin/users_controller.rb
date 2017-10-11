class Admin::UsersController < Admin::ApplicationController
  before_action :user, except: [:index, :new, :create]

  def index
    @users = User.order_name_asc.filter(params[:filter])
    @users = @users.search_with_secondary_emails(params[:search_query]) if params[:search_query].present?
    @users = @users.sort(@sort = params[:sort])
    @users = @users.page(params[:page])
  end

  def show
  end

  def projects
    @personal_projects = user.personal_projects
    @joined_projects = user.projects.joined(@user)
  end

  def keys
    @keys = user.keys.order_id_desc
  end

  def new
    @user = User.new
  end

  def edit
    user
  end

  def impersonate
    if can?(user, :log_in)
      session[:impersonator_id] = current_user.id

      warden.set_user(user, scope: :user)

      Gitlab::AppLogger.info("User #{current_user.username} has started impersonating #{user.username}")

      flash[:alert] = "你正在扮演 #{user.username}"

      redirect_to root_path
    else
      flash[:alert] =
        if user.blocked?
          "你不能扮演被禁用的用户"
        elsif user.internal?
          "你不能扮演内部用户"
        else
          "你不能扮演无法登录的用户"
        end

      redirect_to admin_user_path(user)
    end
  end

  def block
    if update_user { |user| user.block }
      redirect_back_or_admin_user(notice: "禁用成功")
    else
      redirect_back_or_admin_user(alert: "发生错误。用户未被禁止")
    end
  end

  def unblock
    if user.ldap_blocked?
      redirect_back_or_admin_user(alert: "此用户无法通过 GitLab 来启用")
    elsif update_user { |user| user.activate }
      redirect_back_or_admin_user(notice: "启用成功")
    else
      redirect_back_or_admin_user(alert: "发生错误。用户未被启用")
    end
  end

  def unlock
    if update_user { |user| user.unlock_access! }
      redirect_back_or_admin_user(alert: "解除锁定成功")
    else
      redirect_back_or_admin_user(alert: "发生错误。用户未被解除锁定")
    end
  end

  def confirm
    if update_user { |user| user.confirm }
      redirect_back_or_admin_user(notice: "确认成功")
    else
      redirect_back_or_admin_user(alert: "发生错误。用户未被确认")
    end
  end

  def disable_two_factor
    update_user { |user| user.disable_two_factor! }

    redirect_to admin_user_path(user),
      notice: '此用户已禁止两步验证'
  end

  def create
    opts = {
      reset_password: true,
      skip_confirmation: true
    }

    @user = Users::CreateService.new(current_user, user_params.merge(opts)).execute

    respond_to do |format|
      if @user.persisted?
        format.html { redirect_to [:admin, @user], notice: '用户创建成功。' }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    user_params_with_pass = user_params.dup

    if params[:user][:password].present?
      password_params = {
        password: params[:user][:password],
        password_confirmation: params[:user][:password_confirmation]
      }

      password_params[:password_expires_at] = Time.now unless changing_own_password?

      user_params_with_pass.merge!(password_params)
    end

    respond_to do |format|
      result = Users::UpdateService.new(current_user, user_params_with_pass.merge(user: user)).execute do |user|
        user.skip_reconfirmation!
      end

      if result[:status] == :success
        format.html { redirect_to [:admin, user], notice: '用户更新成功。' }
        format.json { head :ok }
      else
        # restore username to keep form action url.
        user.username = params[:id]
        format.html { render "edit" }
        format.json { render json: [result[:message]], status: result[:status] }
      end
    end
  end

  def destroy
    user.delete_async(deleted_by: current_user, params: params.permit(:hard_delete))

    respond_to do |format|
      format.html { redirect_to admin_users_path, status: 302, notice: "用户删除成功。" }
      format.json { head :ok }
    end
  end

  def remove_email
    email = user.emails.find(params[:email_id])
    success = Emails::DestroyService.new(current_user, user: user).execute(email)

    respond_to do |format|
      if success
        format.html { redirect_back_or_admin_user(notice: '删除邮箱成功。') }
        format.json { head :ok }
      else
        format.html { redirect_back_or_admin_user(alert: '删除邮箱出现错误。') }
        format.json { render json: 'There was an error removing the e-mail.', status: 400 }
      end
    end
  end

  protected

  def changing_own_password?
    user == current_user
  end

  def user
    @user ||= User.find_by!(username: params[:id])
  end

  def redirect_back_or_admin_user(options = {})
    redirect_back_or_default(default: default_route, options: options)
  end

  def default_route
    [:admin, @user]
  end

  def user_params
    params.require(:user).permit(user_params_ce)
  end

  def user_params_ce
    [
      :access_level,
      :avatar,
      :bio,
      :can_create_group,
      :color_scheme_id,
      :email,
      :extern_uid,
      :external,
      :force_random_password,
      :hide_no_password,
      :hide_no_ssh_key,
      :key_id,
      :linkedin,
      :name,
      :password_expires_at,
      :projects_limit,
      :provider,
      :remember_me,
      :skype,
      :theme_id,
      :twitter,
      :username,
      :website_url
    ]
  end

  def update_user(&block)
    result = Users::UpdateService.new(current_user, user: user).execute(&block)

    result[:status] == :success
  end
end
