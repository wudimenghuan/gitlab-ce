class SlackSlashCommandsService < SlashCommandsService
  include TriggersHelper

  def title
    'Slack 命令'
  end

  def description
    "在 GitLab 上实现 Slack 的常见操作"
  end

  def self.to_param
    'slack_slash_commands'
  end

  def trigger(params)
    # Format messages to be Slack-compatible
    super.tap do |result|
      result[:text] = format(result[:text]) if result.is_a?(Hash)
    end
  end

  private

  def format(text)
    Slack::Notifier::LinkFormatter.format(text) if text
  end
end
