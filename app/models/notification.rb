#encoding: utf-8
class Notification
  #
  # Notification levels
  #
  N_DISABLED = 0
  N_PARTICIPATING = 1
  N_WATCH = 2
  N_GLOBAL = 3
  N_MENTION = 4

  attr_accessor :target

  class << self
    def notification_levels
      [N_DISABLED, N_MENTION, N_PARTICIPATING, N_WATCH]
    end

    def options_with_labels
      {
        关闭: N_DISABLED,
        参与: N_PARTICIPATING,
        关注: N_WATCH,
        提及: N_MENTION,
        全局: N_GLOBAL
      }
    end

    def project_notification_levels
      [N_DISABLED, N_MENTION, N_PARTICIPATING, N_WATCH, N_GLOBAL]
    end
  end

  def initialize(target)
    @target = target
  end

  def disabled?
    target.notification_level == N_DISABLED
  end

  def participating?
    target.notification_level == N_PARTICIPATING
  end

  def watch?
    target.notification_level == N_WATCH
  end

  def global?
    target.notification_level == N_GLOBAL
  end

  def mention?
    target.notification_level == N_MENTION
  end

  def level
    target.notification_level
  end
  
  def to_s
    case level
    when N_DISABLED
      '关闭'
    when N_PARTICIPATING
      '参与'
    when N_WATCH
      '关注'
    when N_MENTION
      '被提及'
    when N_GLOBAL
      '全局'
    else
      # do nothing      
    end
  end
end
