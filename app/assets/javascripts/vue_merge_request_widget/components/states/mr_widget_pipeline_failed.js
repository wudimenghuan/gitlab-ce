export default {
  name: 'MRWidgetPipelineBlocked',
  template: `
    <div class="mr-widget-body">
      <button
        class="btn btn-success btn-small"
        disabled="true"
        type="button">
        合并
      </button>
      <span class="bold">
        此合并请求的流水线已失败。 请重试该作业或推送一个新的提交来修复失败。
      </span>
    </div>
  `,
};
