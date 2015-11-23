#encoding: utf-8
module SnippetsHelper
  def lifetime_select_options
    options = [
        ['从未', nil],
        ['1 天',   "#{Date.current + 1.day}"],
        ['1 周',  "#{Date.current + 1.week}"],
        ['1 月', "#{Date.current + 1.month}"]
    ]
    options_for_select(options)
  end

  def reliable_snippet_path(snippet)
    if snippet.project_id?
      namespace_project_snippet_path(snippet.project.namespace,
                                     snippet.project, snippet)
    else
      snippet_path(snippet)
    end
  end
end
