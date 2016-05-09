class RepositoryCheckMailer < BaseMailer
  def notify(failed_count)
    if failed_count == 1
      @message = "One project failed its last repository check"
    else
      @message = "#{failed_count} 个项目仓库检查失败"
    end

    mail(
      to: User.admins.pluck(:email),
      subject: "GitLab Admin | #{@message}"
    )
  end
end
