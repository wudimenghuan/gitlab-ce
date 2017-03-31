module NotificationsHelper
  include IconsHelper

  def notification_icon_class(level)
    case level.to_sym
    when :disabled
      'microphone-slash'
    when :participating
      'volume-up'
    when :watch
      'eye'
    when :mention
      'at'
    when :global
      'globe'
    end
  end

  def notification_icon(level, text = nil)
    icon("#{notification_icon_class(level)} fw", text: text)
  end

  def notification_levels
    [
        ['关闭', :disabled],
        ['参与', :participating],
        ['关注', :watch],
        ['全局', :global],
        ['被提及', :mention],
        ['自定义', :custom]
    ]
  end

  def notification_title(level)
    case level.to_sym
    when :disabled
      '关闭'
    when :participating
      '参与'
    when :watch
      '关注'
    when :mention
      '被提及'
    when :global
      '全局'
    when :custom
      '自定义'
    else
      level.to_s.titlecase
    end
  end

  def notification_description(level)
    case level.to_sym
    when :participating
      '您将只收到您参与的主题的通知'
    when :mention
      '您将只收到评论中提及(@)您的通知'
    when :watch
      '您将收到所参与项目的所有活动通知'
    when :disabled
      '您将不会收到任何通知邮件'
    when :global
      '使用您的全局通知设置'
    when :custom
      '您将只收到您所选择的活动的通知'
    end
  end

  def notification_list_item(level, setting)
    title = notification_title(level)

    data = {
      notification_level: level,
      notification_title: title
    }

    content_tag(:li, role: "menuitem") do
      link_to '#', class: "update-notification #{('is-active' if setting.level == level)}", data: data do
        link_output = content_tag(:strong, title, class: 'dropdown-menu-inner-title')
        link_output << content_tag(:span, notification_description(level), class: 'dropdown-menu-inner-content')
      end
    end
  end

  # Identifier to trigger individually dropdowns and custom settings modals in the same view
  def notifications_menu_identifier(type, notification_setting)
    "#{type}-#{notification_setting.user_id}-#{notification_setting.source_id}-#{notification_setting.source_type}"
  end

  # Create hidden field to send notification setting source to controller
  def hidden_setting_source_input(notification_setting)
    return unless notification_setting.source_type
    hidden_field_tag "#{notification_setting.source_type.downcase}_id", notification_setting.source_id
  end

  def notification_event_name(event)
    case event
    when :success_pipeline
      '流水线成功'
    when :new_note
      '新建评论'
    when :new_issue
      '新建问题'
    when :reopen_issue
      '重新打开问题'
    when :close_issue
      '关闭问题'
    when :reassign_issue
      '重新指派问题'
    when :new_merge_request
      '新建合并请求'
    when :reopen_merge_request
      '重新打开合并请求'
    when :close_merge_request
      '关闭合并请求'
    when :reassign_merge_request
      '重新指派合并请求'
    when :merge_merge_request
      '接受合并请求'
    else
      event.to_s.humanize
    end
  end
end
