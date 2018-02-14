import statusIcon from '../mr_widget_status_icon.vue';

export default {
  name: 'MRWidgetUnresolvedDiscussions',
  props: {
    mr: { type: Object, required: true },
  },
  components: {
    statusIcon,
  },
  template: `
    <div class="mr-widget-body media">
      <status-icon status="warning" :show-disabled-button="true" />
      <div class="media-body space-children">
        <span class="bold">
          还有未解决的讨论。请解决这些讨论
        </span>
        <a
          v-if="mr.createIssueToResolveDiscussionsPath"
          :href="mr.createIssueToResolveDiscussionsPath"
          class="btn btn-default btn-xs js-create-issue">
          创建一个问题，以便以后解决
        </a>
      </div>
    </div>
  `,
};
