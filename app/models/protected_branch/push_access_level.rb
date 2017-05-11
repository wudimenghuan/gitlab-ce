class ProtectedBranch::PushAccessLevel < ActiveRecord::Base
  include ProtectedBranchAccess

  validates :access_level, presence: true, inclusion: { in: [Gitlab::Access::MASTER,
                                                             Gitlab::Access::DEVELOPER,
                                                             Gitlab::Access::NO_ACCESS] }

  def self.human_access_levels
    {
      Gitlab::Access::MASTER => "主程序员",
      Gitlab::Access::DEVELOPER => "开发人员 + 主程序员",
      Gitlab::Access::NO_ACCESS => "禁止任何人推送"
    }.with_indifferent_access
  end

  def check_access(user)
    return false if access_level == Gitlab::Access::NO_ACCESS

    super
  end
end
