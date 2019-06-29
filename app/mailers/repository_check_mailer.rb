# frozen_string_literal: true

class RepositoryCheckMailer < BaseMailer
  # rubocop: disable CodeReuse/ActiveRecord
  layout 'empty_mailer'

  helper EmailsHelper

  def notify(failed_count)
    @message =
      if failed_count == 1
        "一个项目仓库检查失败"
      else
        "#{failed_count} 个项目仓库检查失败"
      end

    mail(
      to: User.admins.active.pluck(:email),
      subject: "GitLab 后台 | #{@message}"
    )
  end
  # rubocop: enable CodeReuse/ActiveRecord
end
