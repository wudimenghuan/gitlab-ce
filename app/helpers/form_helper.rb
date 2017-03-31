module FormHelper
  def form_errors(model)
    return unless model.errors.any?

    pluralized = '错误'.pluralize(model.errors.count)
    headline   = "表单包含以下 #{pluralized}:"

    content_tag(:div, class: 'alert alert-danger', id: 'error_explanation') do
      content_tag(:h4, headline) <<
        content_tag(:ul) do
          model.errors.full_messages.
            map { |msg| content_tag(:li, msg) }.
            join.
            html_safe
        end
    end
  end
end
