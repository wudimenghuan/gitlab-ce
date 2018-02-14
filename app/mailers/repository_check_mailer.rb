class RepositoryCheckMailer < BaseMailer
  def notify(failed_count)
    @message =
      if failed_count == 1
        "一个项目仓库检查失败"
      else
        "#{failed_count} 个项目仓库检查失败"
      end

    mail(
      to: User.admins.pluck(:email),
      subject: "GitLab 后台 | #{@message}"
    )
  end
end
