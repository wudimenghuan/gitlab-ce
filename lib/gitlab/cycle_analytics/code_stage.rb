module Gitlab
  module CycleAnalytics
    class CodeStage < BaseStage
      def start_time_attrs
        @start_time_attrs ||= issue_metrics_table[:first_mentioned_in_commit_at]
      end

      def end_time_attrs
        @end_time_attrs ||= mr_table[:created_at]
      end

      def name
        :code
      end

      def legend
        "Related Merge Requests"
      end

      def description
        "第一个合并请求提出的所花费的时间"
      end
    end
  end
end
