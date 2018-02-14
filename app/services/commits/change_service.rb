module Commits
  class ChangeService < Commits::CreateService
    def initialize(*args)
      super

      @commit = params[:commit]
    end

    private

    def action_zh(action)
      case action
      when :revert
        "撤销"
      when :cherry_pick
        "挑选"
      else
        action.to_s.dasherize
      end
    end

    def commit_change(action)
      raise NotImplementedError unless repository.respond_to?(action)

      # rubocop:disable GitlabSecurity/PublicSend
      message = @commit.public_send(:"#{action}_message", current_user)

      # rubocop:disable GitlabSecurity/PublicSend
      repository.public_send(
        action,
        current_user,
        @commit,
        @branch_name,
        message,
        start_project: @start_project,
        start_branch_name: @start_branch)
    rescue Gitlab::Git::Repository::CreateTreeError
      error_msg = "很抱歉，我们无法自动 #{action_zh(action)} 此 #{@commit.change_type_title(current_user)} 。
                   这个 #{@commit.change_type_title(current_user)} 可能已经被 #{action_zh(action)}, 或者最近的提交已经更新了其中的某些内容。"
      raise ChangeError, error_msg
    end
  end
end
