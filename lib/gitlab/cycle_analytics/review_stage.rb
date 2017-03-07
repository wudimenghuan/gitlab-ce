module Gitlab
  module CycleAnalytics
    class ReviewStage < BaseStage
      def start_time_attrs
        @start_time_attrs ||= mr_table[:created_at]
      end

      def end_time_attrs
        @end_time_attrs ||= mr_metrics_table[:merged_at]
      end

      def name
        :review
      end

      def legend
        "Relative Merged Requests"
      end

      def description
        "合并请求从提出到合并所花费的时间"
      end
    end
  end
end
