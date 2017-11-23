export default {
  name: 'MRWidgetMergeHelp',
  props: {
    missingBranch: { type: String, required: false, default: '' },
  },
  template: `
    <section class="mr-widget-help">
      <template
        v-if="missingBranch">
        如果分支 {{missingBranch}} 在您本地的版本库，您
      </template>
      <template v-else>
        您
      </template>
      可以通过
      <a
        data-toggle="modal"
        href="#modal_merge_info">
        命令行
      </a>
      在本地合并这个合并请求。
    </section>
  `,
};
