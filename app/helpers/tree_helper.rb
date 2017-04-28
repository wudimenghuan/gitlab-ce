module TreeHelper
  # Sorts a repository's tree so that folders are before files and renders
  # their corresponding partials
  #
  # contents - A Grit::Tree object for the current tree
  def render_tree(tree)
    # Sort submodules and folders together by name ahead of files
    folders, files, submodules = tree.trees, tree.blobs, tree.submodules
    tree = ""
    items = (folders + submodules).sort_by(&:name) + files
    tree << render(partial: "projects/tree/tree_row", collection: items) if items.present?
    tree.html_safe
  end

  # Return an image icon depending on the file type and mode
  #
  # type - String type of the tree item; either 'folder' or 'file'
  # mode - File unix mode
  # name - File name
  def tree_icon(type, mode, name)
    icon("#{file_type_icon_class(type, mode, name)} fw")
  end

  def tree_hex_class(content)
    "file_#{hexdigest(content.name)}"
  end

  # Simple shortcut to File.join
  def tree_join(*args)
    File.join(*args)
  end

  def on_top_of_branch?(project = @project, ref = @ref)
    project.repository.branch_exists?(ref)
  end

  def can_edit_tree?(project = nil, ref = nil)
    project ||= @project
    ref ||= @ref

    return false unless on_top_of_branch?(project, ref)

    can_collaborate_with_project?(project)
  end

  def tree_edit_branch(project = @project, ref = @ref)
    return unless can_edit_tree?(project, ref)

    if can_push_branch?(project, ref)
      ref
    else
      project = tree_edit_project(project)
      project.repository.next_branch('patch')
    end
  end

  def tree_edit_project(project = @project)
    if can?(current_user, :push_code, project)
      project
    elsif current_user && current_user.already_forked?(project)
      current_user.fork_of(project)
    end
  end

  def edit_in_new_fork_notice_now
    "您不能直接对此项目进行更改。" +
      " 正在派生此项目，您可以在派生项目上进行更改，然后提交合并请求。"
  end

  def edit_in_new_fork_notice
    "您不能直接对此项目进行更改。" +
      " 您已经派生了此项目，请在派生项目上进行更改，然后提交合并请求。"
  end

  def commit_in_fork_help
    "将在您的派生项目中创建一个新分支，并且将创建一个新的合并请求。"
  end

  def tree_breadcrumbs(tree, max_links = 2)
    if @path.present?
      part_path = ""
      parts = @path.split('/')

      yield('..', nil) if parts.count > max_links

      parts.each do |part|
        part_path = File.join(part_path, part) unless part_path.empty?
        part_path = part if part_path.empty?

        next if parts.count > max_links && !parts.last(2).include?(part)
        yield(part, tree_join(@ref, part_path))
      end
    end
  end

  def up_dir_path
    file = File.join(@path, "..")
    tree_join(@ref, file)
  end

  # returns the relative path of the first subdir that doesn't have only one directory descendant
  def flatten_tree(tree)
    subtree = Gitlab::Git::Tree.where(@repository, @commit.id, tree.path)
    if subtree.count == 1 && subtree.first.dir?
      return tree_join(tree.name, flatten_tree(subtree.first))
    else
      return tree.name
    end
  end
end
