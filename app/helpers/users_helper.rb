module UsersHelper
  def user_link(user)
    link_to(user.name, user_path(user),
            title: user.email,
            class: 'has-tooltip commit-committer-link')
  end

  def user_email_help_text(user)
    return '如果用户未上传头像的话，我们也会使用该邮件地址来自动寻找头像。' unless user.unconfirmed_email.present?

    confirmation_link = link_to '重新发送确认电子邮件', user_confirmation_path(user: { email: @user.unconfirmed_email }), method: :post

    h('请在继续前点击确认邮件中的链接，邮件被发往 ') +
      content_tag(:strong) { user.unconfirmed_email } + h('.') +
      content_tag(:p) { confirmation_link }
  end
end
