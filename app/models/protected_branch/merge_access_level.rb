class ProtectedBranch::MergeAccessLevel < ActiveRecord::Base
  include ProtectedBranchAccess

  belongs_to :protected_branch
  delegate :project, to: :protected_branch

  validates :access_level, presence: true, inclusion: { in: [Gitlab::Access::MASTER,
                                                             Gitlab::Access::DEVELOPER] }

  def self.human_access_levels
    {
      Gitlab::Access::MASTER => "主程序员",
      Gitlab::Access::DEVELOPER => "开发人员 + 主程序员"
    }.with_indifferent_access
  end

  def check_access(user)
    return true if user.is_admin?

    project.team.max_member_access(user.id) >= access_level
  end
end
