export default {
  name: 'MRWidgetNotAllowed',
  template: `
    <div class="mr-widget-body">
      <button
        type="button"
        class="btn btn-success btn-small"
        disabled="true">
        合并
      </button>
      <span class="bold">
        已准备好自动合并。
        请询问具有此仓库写权限的成员来合并此请求。
      </span>
    </div>
  `,
};
