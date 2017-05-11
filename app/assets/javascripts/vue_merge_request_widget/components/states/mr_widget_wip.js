/* global Flash */
import eventHub from '../../event_hub';

export default {
  name: 'MRWidgetWIP',
  props: {
    mr: { type: Object, required: true },
    service: { type: Object, required: true },
  },
  data() {
    return {
      isMakingRequest: false,
    };
  },
  methods: {
    removeWIP() {
      this.isMakingRequest = true;
      this.service.removeWIP()
        .then(res => res.json())
        .then((res) => {
          eventHub.$emit('UpdateWidgetData', res);
          new Flash('The merge request can now be merged.', 'notice'); // eslint-disable-line
          $('.merge-request .detail-page-description .title').text(this.mr.title);
        })
        .catch(() => {
          this.isMakingRequest = false;
          new Flash('Something went wrong. Please try again.'); // eslint-disable-line
        });
    },
  },
  template: `
    <div class="mr-widget-body">
      <button
        type="button"
        class="btn btn-success btn-small"
        disabled="true">
        合并</button>
      <span class="bold">
        此合并请求当前正在进行中，因此无法合并
      </span>
      <template v-if="mr.removeWIPPath">
        <i
          class="fa fa-question-circle has-tooltip"
          title="当此合并请求准备就绪时，从标题中删除 WIP: 前缀以允许其合并。" />
        <button
          @click="removeWIP"
          :disabled="isMakingRequest"
          type="button"
          class="btn btn-default btn-xs js-remove-wip">
          <i
            v-if="isMakingRequest"
            class="fa fa-spinner fa-spin"
            aria-hidden="true" />
            解决 WIP 状态
        </button>
      </template>
    </div>
  `,
};
