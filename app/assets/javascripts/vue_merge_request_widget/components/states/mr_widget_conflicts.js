import statusIcon from '../mr_widget_status_icon';

export default {
  name: 'MRWidgetConflicts',
  props: {
    mr: { type: Object, required: true },
  },
  components: {
    statusIcon,
  },
  template: `
    <div class="mr-widget-body media">
      <status-icon status="failed" showDisabledButton />
      <div class="media-body space-children">
        <span class="bold">
          合并请求包含有合并冲突<span v-if="!mr.canMerge">。</span>
          <span v-if="!mr.canMerge">
            请解决这些冲突或者请求具有推送权限的成员在本地合并。
          </span>
        </span>
        <a
          v-if="mr.canMerge && mr.conflictResolutionPath"
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
