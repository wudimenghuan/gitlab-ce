module Ci
  class LintsController < ApplicationController
    before_action :authenticate_user!

    def show
    end

    def create
      if params[:content].blank?
        @status = false
        @error = "请提供 .gitlab-ci.yml 文件内容"
      else
        @config_processor = Ci::GitlabCiYamlProcessor.new params[:content]
        @stages = @config_processor.stages
        @builds = @config_processor.builds
        @status = true
      end
    rescue Ci::GitlabCiYamlProcessor::ValidationError, Psych::SyntaxError => e
      @error = e.message
      @status = false
    rescue
      @error = "未定义错误"
      @status = false
    end
  end
end
