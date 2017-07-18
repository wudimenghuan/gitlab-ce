export default {
  name: 'MRWidgetPipelineBlocked',
  template: `
    <div class="mr-widget-body">
      <button
        type="button"
        class="btn btn-success btn-small"
        disabled="true">
        合并
      </button>
      <span class="bold">
        流水线被停用。 此合并请求的流水线需要手动操作才能继续。
      </span>
    </div>
  `,
};
