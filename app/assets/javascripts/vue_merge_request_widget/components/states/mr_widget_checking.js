export default {
  name: 'MRWidgetChecking',
  template: `
    <div class="mr-widget-body">
      <button
        type="button"
        class="btn btn-success btn-small"
        disabled="true">
        合并
      </button>
      <span class="bold">
        正在进行自动合并检查
        <i
          class="fa fa-spinner fa-spin"
          aria-hidden="true" />
      </span>
    </div>
  `,
};
