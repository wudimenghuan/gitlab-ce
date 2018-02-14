module SearchHelper
  def search_autocomplete_opts(term)
    return unless current_user

    resources_results = [
      groups_autocomplete(term),
      projects_autocomplete(term)
    ].flatten

    search_pattern = Regexp.new(Regexp.escape(term), "i")

    generic_results = project_autocomplete + default_autocomplete + help_autocomplete
    generic_results.concat(default_autocomplete_admin) if current_user.admin?
    generic_results.select! { |result| result[:label] =~ search_pattern }

    [
      resources_results,
      generic_results
    ].flatten.uniq do |item|
      item[:label]
    end
  end

  def search_entries_info(collection, scope, term)
    return unless collection.count > 0

    from = collection.offset_value + 1
    to = collection.offset_value + collection.length
    count = collection.total_count

    "显示 \"#{term}\" 的 #{from} - #{to} of #{count} #{scope.humanize(capitalize: false)}"
  end

  def parse_search_result(result)
    Gitlab::ProjectSearchResults.parse_search_result(result)
  end

  private

  # Autocomplete results for various settings pages
  def default_autocomplete
    [
      { category: "设置", label: "个人设置",    url: profile_path },
      { category: "设置", label: "SSH 密钥",         url: profile_keys_path },
      { category: "设置", label: "仪表板",        url: root_path }
    ]
  end

  # Autocomplete results for settings pages, for admins
  def default_autocomplete_admin
    [
      { category: "设置", label: "后台管理", url: admin_root_path }
    ]
  end

  # Autocomplete results for internal help pages
  def help_autocomplete
    [
      { category: "帮助", label: "API 帮助",           url: help_page_path("api/README") },
      { category: "帮助", label: "Markdown 帮助",      url: help_page_path("user/markdown") },
      { category: "帮助", label: "权限帮助",   url: help_page_path("user/permissions") },
      { category: "帮助", label: "公开访问帮助", url: help_page_path("public_access/public_access") },
      { category: "帮助", label: "Rake 任务帮助",    url: help_page_path("raketasks/README") },
      { category: "帮助", label: "SSH 密钥帮助",      url: help_page_path("ssh/README") },
      { category: "帮助", label: "系统钩子帮助",  url: help_page_path("system_hooks/system_hooks") },
      { category: "帮助", label: "Webhooks 帮助",      url: help_page_path("user/project/integrations/webhooks") },
      { category: "帮助", label: "工作流帮助",      url: help_page_path("workflow/README") }
    ]
  end

  # Autocomplete results for the current project, if it's defined
  def project_autocomplete
    if @project && @project.repository.exists? && @project.repository.root_ref
      ref = @ref || @project.repository.root_ref

      [
        { category: "当前项目", label: "文件",                  url: project_tree_path(@project, ref) },
        { category: "当前项目", label: "提交",                  url: project_commits_path(@project, ref) },
        { category: "当前项目", label: "网络",                  url: project_network_path(@project, ref) },
        { category: "当前项目", label: "图表",                  url: project_graph_path(@project, ref) },
        { category: "当前项目", label: "问题",                  url: project_issues_path(@project) },
        { category: "当前项目", label: "合并请求",              url: project_merge_requests_path(@project) },
        { category: "当前项目", label: "里程碑",                url: project_milestones_path(@project) },
        { category: "当前项目", label: "代码片段",              url: project_snippets_path(@project) },
        { category: "当前项目", label: "成员",                  url: project_project_members_path(@project) },
        { category: "当前项目", label: "维基",                  url: project_wikis_path(@project) }
      ]
    else
      []
    end
  end

  # Autocomplete results for the current user's groups
  def groups_autocomplete(term, limit = 5)
    current_user.authorized_groups.order_id_desc.search(term).limit(limit).map do |group|
      {
        category: "群组",
        id: group.id,
        label: "#{search_result_sanitize(group.full_name)}",
        url: group_path(group)
      }
    end
  end

  # Autocomplete results for the current user's projects
  def projects_autocomplete(term, limit = 5)
    current_user.authorized_projects.order_id_desc.search_by_title(term)
      .sorted_by_stars.non_archived.limit(limit).map do |p|
      {
        category: "项目",
        id: p.id,
        value: "#{search_result_sanitize(p.name)}",
        label: "#{search_result_sanitize(p.name_with_namespace)}",
        url: project_path(p)
      }
    end
  end

  def search_result_sanitize(str)
    Sanitize.clean(str)
  end

  def search_filter_path(options = {})
    exist_opts = {
      search: params[:search],
      project_id: params[:project_id],
      group_id: params[:group_id],
      scope: params[:scope],
      repository_ref: params[:repository_ref]
    }

    options = exist_opts.merge(options)
    search_path(options)
  end

  def search_filter_input_options(type)
    opts =
      {
        id: "filtered-search-#{type}",
        placeholder: '搜索或者过滤结果...',
        data: {
          'username-params' => UserSerializer.new.represent(@users)
        },
        autocomplete: 'off'
      }

    if @project.present?
      opts[:data]['project-id'] = @project.id
      opts[:data]['base-endpoint'] = project_path(@project)
    else
      # Group context
      opts[:data]['group-id'] = @group.id
      opts[:data]['base-endpoint'] = group_canonical_path(@group)
    end

    opts
  end

  # Sanitize a HTML field for search display. Most tags are stripped out and the
  # maximum length is set to 200 characters.
  def search_md_sanitize(object, field)
    html = markdown_field(object, field)
    html = Truncato.truncate(
      html,
      count_tags: false,
      count_tail: false,
      max_length: 200
    )

    # Truncato's filtered_tags and filtered_attributes are not quite the same
    sanitize(html, tags: %w(a p ol ul li pre code))
  end

  def limited_count(count, limit = 1000)
    count > limit ? "#{limit}+" : count
  end
end
