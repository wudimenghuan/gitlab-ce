export default {
  name: 'MRWidgetAutoMergeFailed',
  props: {
    mr: { type: Object, required: true },
  },
  template: `
    <div class="mr-widget-body">
      <button
        class="btn btn-success btn-small"
        disabled="true"
        type="button">
        合并
      </button>
      <span class="bold danger">
        这个合并请求无法自动合并。
      </span>
      <div class="merge-error-text">
        {{mr.mergeError}}
      </div>
    </div>
  `,
};
