export default {
  name: 'MRWidgetUnresolvedDiscussions',
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
        还有未解决的讨论。 请解决这些讨论
        <span v-if="mr.canCreateIssue">or</span>
        <span v-else>.</span>
      </span>
      <a
        v-if="mr.createIssueToResolveDiscussionsPath"
        :href="mr.createIssueToResolveDiscussionsPath"
        class="btn btn-default btn-xs js-create-issue">
        创建一个问题，以便以后解决
      </a>
    </div>
  `,
};
