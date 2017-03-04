module Files
  class BaseService < ::BaseService
    class ValidationError < StandardError; end

    def execute
      @start_project = params[:start_project] || @project
      @start_branch = params[:start_branch]
      @target_branch = params[:target_branch]

      @commit_message = params[:commit_message]
      @file_path      = params[:file_path]
      @previous_path  = params[:previous_path]
      @file_content   = if params[:file_content_encoding] == 'base64'
                          Base64.decode64(params[:file_content])
                        else
                          params[:file_content]
                        end
      @last_commit_sha = params[:last_commit_sha]
      @author_email    = params[:author_email]
      @author_name     = params[:author_name]

      # Validate parameters
      validate

      # Create new branch if it different from start_branch
      validate_target_branch if different_branch?

      result = commit
      if result
        success(result: result)
      else
        error('出错了，您的变更未提交')
      end
    rescue Repository::CommitError, Gitlab::Git::Repository::InvalidBlobName, GitHooksService::PreReceiveError, ValidationError => ex
      error(ex.message)
    end

    private

    def different_branch?
      @start_branch != @target_branch || @start_project != @project
    end

    def file_has_changed?
      return false unless @last_commit_sha && last_commit

      @last_commit_sha != last_commit.sha
    end

    def raise_error(message)
      raise ValidationError.new(message)
    end

    def validate
      allowed = ::Gitlab::UserAccess.new(current_user, project: project).can_push_to_branch?(@target_branch)

      unless allowed
        raise_error("您不允许推送到此分支")
      end

      if !@start_project.empty_repo? && !@start_project.repository.branch_exists?(@start_branch)
        raise ValidationError, '您只能在分支上创建或编辑文件'
      end

      if !project.empty_repo? && different_branch? && repository.branch_exists?(@branch_name)
        raise ValidationError, "分支 #{@branch_name} 已存在。您需要切换到该分支以进行更改"
      end
    end

    def validate_target_branch
      result = ValidateNewBranchService.new(project, current_user).
        execute(@target_branch)

      if result[:status] == :error
        raise_error("为您创建分支 #{@target_branch} 时发生了错误：#{result[:message]}")
      end
    end
  end
end
