export default {
  name: 'MRWidgetSHAMismatch',
  template: `
    <div class="mr-widget-body">
      <button
        type="button"
        class="btn btn-success btn-small"
        disabled="true">
        合并
      </button>
      <span class="bold">
        源分支的 HEAD 在最近发生了变更。 请重新加载页面，并在合并之前查看更改。
      </span>
    </div>
  `,
};
