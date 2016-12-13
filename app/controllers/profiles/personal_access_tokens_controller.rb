class Profiles::PersonalAccessTokensController < Profiles::ApplicationController
  before_action :load_personal_access_tokens, only: :index

  def index
    @personal_access_token = current_user.personal_access_tokens.build
  end

  def create
    @personal_access_token = current_user.personal_access_tokens.generate(personal_access_token_params)

    if @personal_access_token.save
      flash[:personal_access_token] = @personal_access_token.token
      redirect_to profile_personal_access_tokens_path, notice: "您已创建新的个人访问令牌。"
    else
      load_personal_access_tokens
      render :index
    end
  end

  def revoke
    @personal_access_token = current_user.personal_access_tokens.find(params[:id])

    if @personal_access_token.revoke!
      flash[:notice] = "撤销个人访问令牌 #{@personal_access_token.name}!"
    else
      flash[:alert] = "无法撤销个人访问令牌 #{@personal_access_token.name}."
    end

    redirect_to profile_personal_access_tokens_path
  end

  private

  def personal_access_token_params
    params.require(:personal_access_token).permit(:name, :expires_at)
  end

  def load_personal_access_tokens
    @active_personal_access_tokens = current_user.personal_access_tokens.active.order(:expires_at)
    @inactive_personal_access_tokens = current_user.personal_access_tokens.inactive
  end
end
