module MembershipActions
  extend ActiveSupport::Concern

  def request_access
    membershipable.request_access(current_user)

    redirect_to polymorphic_path(membershipable),
                notice: '您的访问请求正在等待审核。'
  end

  def approve_access_request
    Members::ApproveAccessRequestService.new(membershipable, current_user, params).execute

    redirect_to polymorphic_url([membershipable, :members])
  end

  def leave
    member = Members::DestroyService.new(membershipable, current_user, user_id: current_user.id).
      execute(:all)

    source_type = membershipable.class.to_s.humanize(capitalize: false)
    notice =
      if member.request?
        "您向 #{source_type} 提交的访问请求被撤回。"
      else
        "你离开了 \"#{@member.source.human_name}\" #{source_type}."
      end
    redirect_path = member.request? ? member.source : [:dashboard, membershipable.class.to_s.tableize]

    redirect_to redirect_path, notice: notice
  end

  protected

  def membershipable
    raise NotImplementedError
  end
end
