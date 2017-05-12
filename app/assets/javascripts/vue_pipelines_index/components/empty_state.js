import pipelinesEmptyStateSVG from 'empty_states/icons/_pipelines_empty.svg';

export default {
  props: {
    helpPagePath: {
      type: String,
      required: true,
    },
  },

  template: `
    <div class="row empty-state js-empty-state">
      <div class="col-xs-12">
        <div class="svg-content">
          ${pipelinesEmptyStateSVG}
        </div>
      </div>

      <div class="col-xs-12 text-center">
        <div class="text-content">
          <h4>可信赖的构建</h4>
          <p>
            持续集成可以通过自动运行测试用例来帮助捕获 Bug，
            而持续部署可以帮助您将代码发布到生产环境。
          </p>
          <a :href="helpPagePath" class="btn btn-info">
            开始使用流水线
          </a>
        </div>
      </div>
    </div>
  `,
};
