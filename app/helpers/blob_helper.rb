#encoding: utf-8
module BlobHelper
  def highlight(blob_name, blob_content, nowrap: false, continue: false)
    @formatter ||= Rouge::Formatters::HTMLGitlab.new(
      nowrap: nowrap,
      cssclass: 'code highlight',
      lineanchors: true,
      lineanchorsid: 'LC'
    )

    begin
      @lexer ||= Rouge::Lexer.guess(filename: blob_name, source: blob_content).new
      result = @formatter.format(@lexer.lex(blob_content, continue: continue)).html_safe
    rescue
      @lexer = Rouge::Lexers::PlainText
      result = @formatter.format(@lexer.lex(blob_content)).html_safe
    end

    result
  end

  def no_highlight_files
    %w(credits changelog news copying copyright license authors)
  end

  def edit_blob_link(project, ref, path, options = {})
    blob =
      begin
        project.repository.blob_at(ref, path)
      rescue
        nil
      end

    if blob && blob.text?
      text = '编辑'
      after = options[:after] || ''
      from_mr = options[:from_merge_request_id]
      link_opts = {}
      link_opts[:from_merge_request_id] = from_mr if from_mr
      cls = 'btn btn-small'
      if allowed_tree_edit?(project, ref)
        link_to(text,
                namespace_project_edit_blob_path(project.namespace, project,
                                                 tree_join(ref, path),
                                                 link_opts),
                class: cls
               )
      else
        content_tag :span, text, class: cls + ' disabled'
      end + after.html_safe
    else
      ''
    end
  end

  def leave_edit_message
    "离开编辑模式？\n所有未保存的修改都会丢失。"
  end

  def editing_preview_title(filename)
    if Gitlab::MarkupHelper.previewable?(filename)
      '预览'
    else
      '预览修改'
    end
  end

  # Return an image icon depending on the file mode and extension
  #
  # mode - File unix mode
  # mode - File name
  def blob_icon(mode, name)
    icon("#{file_type_icon_class('file', mode, name)} fw")
  end
end
