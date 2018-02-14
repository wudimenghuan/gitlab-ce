# Gitlab::Access module
#
# Define allowed roles that can be used
# in GitLab code to determine authorization level
#
module Gitlab
  module Access
    AccessDeniedError = Class.new(StandardError)

    NO_ACCESS = 0
    GUEST     = 10
    REPORTER  = 20
    DEVELOPER = 30
    MASTER    = 40
    OWNER     = 50

    # Branch protection settings
    PROTECTION_NONE          = 0
    PROTECTION_DEV_CAN_PUSH  = 1
    PROTECTION_FULL          = 2
    PROTECTION_DEV_CAN_MERGE = 3

    class << self
      delegate :values, to: :options

      def all_values
        options_with_owner.values
      end

      def options
        {
          "访客"     => GUEST,
          "报告者"   => REPORTER,
          "开发人员" => DEVELOPER,
          "主程序员" => MASTER
        }
      end

      def options_with_owner
        options.merge(
          "所有者"   => OWNER
        )
      end

      def sym_options
        {
          guest:     GUEST,
          reporter:  REPORTER,
          developer: DEVELOPER,
          master:    MASTER
        }
      end

      def sym_options_with_owner
        sym_options.merge(owner: OWNER)
      end

      def protection_options
        {
          "不保护：开发人员和主程序员都可以推送新提交、强制推送和删除分支。" => PROTECTION_NONE,
          "防止推送：开发人员无法推送新的提交，但允许接受合并请求到分支，主程序员可推送新的提交。" => PROTECTION_DEV_CAN_MERGE,
          "部分保护：主程序员和开发人员可以推送新提交，但不能强制推送和删除分支。" => PROTECTION_DEV_CAN_PUSH,
          "完全保护：开发人员不能推送新提交，只有主程序员可以，不允许任何人强制推送或删除分支。" => PROTECTION_FULL
        }
      end

      def protection_values
        protection_options.values
      end

      def human_access(access)
        options_with_owner.key(access)
      end
    end

    def human_access
      Gitlab::Access.human_access(access_field)
    end

    def owner?
      access_field == OWNER
    end
  end
end
