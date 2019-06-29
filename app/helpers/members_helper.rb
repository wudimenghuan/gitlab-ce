# frozen_string_literal: true

module MembersHelper
  def remove_member_message(member, user: nil)
    user = current_user if defined?(current_user)
    text = '您确定要'

    action =
      if member.request?
        if member.user == user
          "撤销对 #{member.source.human_name} #{member.real_source_type_zh} 的访问请求？"
        else
          "拒绝 #{member.user.name} 对 #{member.source.human_name} #{member.real_source_type_zh} 的访问请求？"
        end
      elsif member.invite?
        "撤销对 #{member.invite_email} 加入 #{member.source.human_name} #{member.real_source_type_zh} 的邀请？"
      else
        "将 #{member.user.name} 从 #{member.source.human_name} #{member.real_source_type_zh} 中移除？"
      end

    "#{text} #{action} the #{member.source.human_name} #{source_text(member)}?"
  end

  def remove_member_title(member)
    action = member.request? ? 'Deny access request' : 'Remove user'

    "#{action} from #{source_text(member)}"
  end

  def leave_confirmation_message(member_source)
    "你确定要离开 " \
    "\"#{member_source.human_name}\" #{member_source.class.to_s.humanize(capitalize: false)}?"
  end

  def filter_group_project_member_path(options = {})
    options = params.slice(:search, :sort).merge(options).permit!
    "#{request.path}?#{options.to_param}"
  end

  private

  def source_text(member)
    type = member.real_source_type.humanize(capitalize: false)

    return type if member.request? || member.invite? || type != 'group'

    'group and any subresources'
  end
end
