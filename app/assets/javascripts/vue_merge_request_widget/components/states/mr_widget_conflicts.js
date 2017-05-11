export default {
  name: 'MRWidgetConflicts',
  props: {
    mr: { type: Object, required: true },
  },
  template: `
    <div class="mr-widget-body">
      <button
        type="button"
        class="btn btn-success btn-small"
        disabled="true">
        合并
      </button>
      <span class="bold">
        合并请求包含有合并冲突
        <span v-if="!mr.canMerge">
          请解决这些冲突或者请求具有推送权限的成员在本地合并。
        </span>
      </span>
      <div
        v-if="mr.canMerge"
        class="btn-group">
        <a
          v-if="mr.conflictResolutionPath"
          :href="mr.conflictResolutionPath"
          class="btn btn-default btn-xs js-resolve-conflicts-button">
          解决冲突
        </a>
        <a
          v-if="mr.canMerge"
          class="btn btn-default btn-xs js-merge-locally-button"
          data-toggle="modal"
          href="#modal_merge_info">
          本地合并
        </a>
      </div>
    </div>
  `,
};
