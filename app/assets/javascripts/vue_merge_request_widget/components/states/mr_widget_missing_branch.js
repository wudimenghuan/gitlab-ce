import mrWidgetMergeHelp from '../../components/mr_widget_merge_help';

export default {
  name: 'MRWidgetMissingBranch',
  props: {
    mr: { type: Object, required: true },
  },
  components: {
    'mr-widget-merge-help': mrWidgetMergeHelp,
  },
  computed: {
    missingBranchName() {
      return this.mr.sourceBranchRemoved ? 'source' : 'target';
    },
  },
  template: `
    <div class="mr-widget-body">
      <button
        type="button"
        class="btn btn-success btn-small"
        disabled="true">
        合并
      </button>
      <span class="bold js-branch-text">
        <span class="capitalize">
          {{missingBranchName}}
        </span> 分支不存在。
        请恢复 {{missingBranchName}} 分支 或者使用另一个 {{missingBranchName}} 分支。
      </span>
      <mr-widget-merge-help
        :missing-branch="missingBranchName" />
    </div>
  `,
};
