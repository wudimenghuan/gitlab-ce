class Projects::CycleAnalyticsController < Projects::ApplicationController
  include ActionView::Helpers::DateHelper
  include ActionView::Helpers::TextHelper
  include CycleAnalyticsParams

  before_action :authorize_read_cycle_analytics!

  def show
    @cycle_analytics = ::CycleAnalytics.new(@project, from: start_date(cycle_analytics_params))

    respond_to do |format|
      format.html
      format.json { render json: cycle_analytics_json }
    end
  end

  private

  def cycle_analytics_params
    return {} unless params[:cycle_analytics].present?

    { start_date: params[:cycle_analytics][:start_date] }
  end

  def cycle_analytics_json
    cycle_analytics_view_data = [[:issue, "问题", "一个问题从提出到制定计划的时间"],
                                 [:plan, "计划", "一个问题从提出到开始实现的时间"],
                                 [:code, "代码", "从开发到提出第一次合并请求时间"],
                                 [:test, "测试", "所有提交、合并的测试时间汇总"],
                                 [:review, "评审", "合并请求从提出到合并(关闭)的时间"],
                                 [:staging, "阶段", "从合并请求被合并到生产发布的时间"],
                                 [:production, "生产", "从提出问题到生产发布的时间"]]

    stats = cycle_analytics_view_data.reduce([]) do |stats, (stage_method, stage_text, stage_description)|
      value = @cycle_analytics.send(stage_method).presence

      stats << {
        title: stage_text,
        description: stage_description,
        value: value && !value.zero? ? distance_of_time_in_words(value) : nil
      }
      stats
    end

    issues = @cycle_analytics.summary.new_issues
    commits = @cycle_analytics.summary.commits
    deploys = @cycle_analytics.summary.deploys

    summary = [
      { title: "新建问题数", value: issues },
      { title: "提交数", value: commits },
      { title: "部署次数", value: deploys }
    ]

    {
      summary: summary,
      stats: stats
    }
  end
end
