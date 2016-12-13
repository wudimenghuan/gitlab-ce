class Projects::CycleAnalyticsController < Projects::ApplicationController
  include ActionView::Helpers::DateHelper
  include ActionView::Helpers::TextHelper
  include CycleAnalyticsParams

  before_action :authorize_read_cycle_analytics!

  def show
    @cycle_analytics = ::CycleAnalytics.new(@project, current_user, from: start_date(cycle_analytics_params))

    stats_values, cycle_analytics_json = generate_cycle_analytics_data

    @cycle_analytics_no_data = stats_values.blank?

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

  def generate_cycle_analytics_data
    stats_values = []

    cycle_analytics_view_data = [[:issue, "问题", "相关问题", "一个问题从提出到制定计划的时间"],
                                 [:plan, "计划", "相关提交", "一个问题从提出到开始实现的时间"],
                                 [:code, "代码", "相关合并请求", "编写代码的时间"],
                                 [:test, "测试", "由提交触发的构建", "构建和测试程序所花费的时间"],
                                 [:review, "评审", "已合并的合并请求", "评审代码所花费的时间"],
                                 [:staging, "预发布", "已部署的构建", "预发布所花费的时间"],
                                 [:production, "生产", "相关问题", "产品从概念提出到生产发布的时间"]]

    stats = cycle_analytics_view_data.reduce([]) do |stats, (stage_method, stage_text, stage_legend, stage_description)|
      value = @cycle_analytics.send(stage_method).presence

      stats_values << value.abs if value

      stats << {
        title: stage_text,
        description: stage_description,
        legend: stage_legend,
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

    cycle_analytics_hash = { summary: summary,
                             stats: stats,
                             permissions: @cycle_analytics.permissions(user: current_user)
    }

    [stats_values, cycle_analytics_hash]
  end
end
