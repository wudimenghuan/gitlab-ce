module Gitlab
  module CycleAnalytics
    class ProductionStage < BaseStage
      include ProductionHelper

      def start_time_attrs
        @start_time_attrs ||= issue_table[:created_at]
      end

      def end_time_attrs
        @end_time_attrs ||= mr_metrics_table[:first_deployed_to_production_at]
      end

      def name
        :production
      end

      def title
        s_('CycleAnalyticsStage|Production')
      end

      def legend
        _("关联问题")
      end

      def description
        _("产品从概念提出到生产发布的时间")
      end

      def query
        # Limit to merge requests that have been deployed to production after `@from`
        query.where(mr_metrics_table[:first_deployed_to_production_at].gteq(@from))
      end
    end
  end
end
