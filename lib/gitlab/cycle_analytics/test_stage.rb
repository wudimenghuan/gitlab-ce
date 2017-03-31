module Gitlab
  module CycleAnalytics
    class TestStage < BaseStage
      def start_time_attrs
        @start_time_attrs ||= mr_metrics_table[:latest_build_started_at]
      end

      def end_time_attrs
        @end_time_attrs ||= mr_metrics_table[:latest_build_finished_at]
      end

      def name
        :test
      end

      def legend
        "Relative Builds Trigger by Commits"
      end

      def description
        "所有提交及合并请求测试所花费的时间"
      end

      def stage_query
        if @options[:branch]
          super.where(build_table[:ref].eq(@options[:branch]))
        else
          super
        end
      end
    end
  end
end
