module ButtonHelper
  # Output a "Copy to Clipboard" button
  #
  # data - Data attributes passed to `content_tag`
  #
  # Examples:
  #
  #   # Define the clipboard's text
  #   clipboard_button(clipboard_text: "Foo")
  #   # => "<button class='...' data-clipboard-text='Foo'>...</button>"
  #
  #   # Define the target element
  #   clipboard_button(clipboard_target: "div#foo")
  #   # => "<button class='...' data-clipboard-target='div#foo'>...</button>"
  #
  # See http://clipboardjs.com/#usage
  def clipboard_button(data = {})
    css_class = data[:class] || 'btn-clipboard btn-transparent'
    title = data[:title] || '复制到剪贴板'
    data = { toggle: 'tooltip', placement: 'bottom', container: 'body' }.merge(data)
    content_tag :button,
      icon('clipboard'),
      class: "btn #{css_class}",
      data: data,
      type: :button,
      title: title
  end

  def http_clone_button(project, placement = 'right', append_link: true)
    klass = 'http-selector'
    klass << ' has-tooltip' if current_user.try(:require_password?)

    protocol = gitlab_config.protocol.upcase

    content_tag (append_link ? :a : :span), protocol,
      class: klass,
      href: (project.http_url_to_repo if append_link),
      data: {
        html: true,
        placement: placement,
        container: 'body',
        title: "在账户中设置密码<br>然后再使用 #{protocol} 拉取和推送。"
      }
  end

  def ssh_clone_button(project, placement = 'right', append_link: true)
    klass = 'ssh-selector'
    klass << ' has-tooltip' if current_user.try(:require_ssh_key?)

    content_tag (append_link ? :a : :span), 'SSH',
      class: klass,
      href: (project.ssh_url_to_repo if append_link),
      data: {
        html: true,
        placement: placement,
        container: 'body',
        title: '在个人资料中增加 SSH 密钥<br>然后再使用 SSH 拉取和推送。'
      }
  end
end
