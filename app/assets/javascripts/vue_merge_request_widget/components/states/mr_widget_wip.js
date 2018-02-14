import statusIcon from '../mr_widget_status_icon.vue';
import tooltip from '../../../vue_shared/directives/tooltip';
import eventHub from '../../event_hub';

export default {
  name: 'MRWidgetWIP',
  props: {
    mr: { type: Object, required: true },
    service: { type: Object, required: true },
  },
  directives: {
    tooltip,
  },
  data() {
    return {
      isMakingRequest: false,
    };
  },
  components: {
    statusIcon,
  },
  methods: {
    removeWIP() {
      this.isMakingRequest = true;
      this.service.removeWIP()
        .then(res => res.data)
        .then((data) => {
          eventHub.$emit('UpdateWidgetData', data);
          new window.Flash('该合并请求无法合并。', 'notice'); // eslint-disable-line
          $('.merge-request .detail-page-description .title').text(this.mr.title);
        })
        .catch(() => {
          this.isMakingRequest = false;
          new window.Flash('出现了错误，请重试。'); // eslint-disable-line
        });
    },
  },
  template: `
    <div class="mr-widget-body media">
      <status-icon status="warning" :show-disabled-button="Boolean(mr.removeWIPPath)" />
      <div class="media-body space-children">
        <span class="bold">
          此合并请求当前正在进行中
          <i
            v-tooltip
            class="fa fa-question-circle"
            title="当此合并请求准备就绪时，从标题中删除 WIP: 前缀以允许其合并。"
            aria-label="当此合并请求准备就绪时，从标题中删除 WIP: 前缀以允许其合并。">
           </i>
        </span>
        <button
          v-if="mr.removeWIPPath"
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
      </div>
    </div>
  `,
};
