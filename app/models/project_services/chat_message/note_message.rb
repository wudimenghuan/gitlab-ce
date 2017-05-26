module ChatMessage
  class NoteMessage < BaseMessage
    attr_reader :note
    attr_reader :note_url
    attr_reader :title
    attr_reader :target

    def initialize(params)
      super

      params = HashWithIndifferentAccess.new(params)
      obj_attr = params[:object_attributes]
      @note = obj_attr[:note]
      @note_url = obj_attr[:url]
      @target, @title = case obj_attr[:noteable_type]
                        when "Commit"
                          create_commit_note(params[:commit])
                        when "Issue"
                          create_issue_note(params[:issue])
                        when "MergeRequest"
                          create_merge_note(params[:merge_request])
                        when "Snippet"
                          create_snippet_note(params[:snippet])
                        end
    end

    def attachments
      return note if markdown

      description_message
    end

    def activity
      {
        title: "#{user_name} #{link('评论了 ' + target, note_url)}",
        subtitle: "于 #{project_link}",
        text: formatted_title,
        image: user_avatar
      }
    end

    private

    def message
      "#{user_name} #{link('评论了 ' + target, note_url)} 于 #{project_link}: *#{formatted_title}*"
    end

    def format_title(title)
      title.lines.first.chomp
    end

    def formatted_title
      format_title(title)
    end

    def create_issue_note(issue)
      ["问题 #{Issue.reference_prefix}#{issue[:iid]}", issue[:title]]
    end

    def create_commit_note(commit)
      commit_sha = Commit.truncate_sha(commit[:id])

      ["提交 #{commit_sha}", commit[:message]]
    end

    def create_merge_note(merge_request)
      ["合并请求 #{MergeRequest.reference_prefix}#{merge_request[:iid]}", merge_request[:title]]
    end

    def create_snippet_note(snippet)
      ["代码片段 #{Snippet.reference_prefix}#{snippet[:id]}", snippet[:title]]
    end

    def description_message
      [{ text: format(note), color: attachment_color }]
    end

    def project_link
      link(project_name, project_url)
    end
  end
end
