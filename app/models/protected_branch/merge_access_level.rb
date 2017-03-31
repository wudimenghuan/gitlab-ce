class ProtectedBranch::MergeAccessLevel < ActiveRecord::Base
  include ProtectedBranchAccess

  validates :access_level, presence: true, inclusion: { in: [Gitlab::Access::MASTER,
                                                             Gitlab::Access::DEVELOPER] }

  def self.human_access_levels
    {
      Gitlab::Access::MASTER => "主程序员",
      Gitlab::Access::DEVELOPER => "开发人员 + 主程序员"
    }.with_indifferent_access
  end
end
