module MembershipActions
  extend ActiveSupport::Concern
  include MembersHelper

  def request_access
    membershipable.request_access(current_user)

    redirect_to polymorphic_path(membershipable),
                notice: '您的访问请求正在等待审核。'
  end

  def approve_access_request
    @member = membershipable.requesters.find(params[:id])

    return render_403 unless can?(current_user, action_member_permission(:update, @member), @member)

    @member.accept_request

    redirect_to polymorphic_url([membershipable, :members])
  end

  def leave
    @member = membershipable.members.find_by(user_id: current_user) ||
      membershipable.requesters.find_by(user_id: current_user)
    Members::DestroyService.new(@member, current_user).execute

    source_type = @member.real_source_type.humanize(capitalize: false)
    notice =
      if @member.request?
        "您向 #{source_type} 提交的访问请求被撤回。"
      else
        "你离开了 \"#{@member.source.human_name}\" #{source_type}."
      end
    redirect_path = @member.request? ? @member.source : [:dashboard, @member.real_source_type.tableize]

    redirect_to redirect_path, notice: notice
  end

  protected

  def membershipable
    raise NotImplementedError
  end
end
