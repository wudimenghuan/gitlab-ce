export default {
  name: 'MRWidgetNothingToMerge',
  template: `
    <div class="mr-widget-body">
      <button
        type="button"
        class="btn btn-success btn-small"
        disabled="true">
        合并
      </button>
      <span class="bold">
        没有什么需要从源分支合并到目标分支。
        请推送新的提交或者选择另一个源分支。
      </span>
    </div>
  `,
};
