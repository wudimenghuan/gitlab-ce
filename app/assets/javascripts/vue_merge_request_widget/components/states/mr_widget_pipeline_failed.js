import statusIcon from '../mr_widget_status_icon';

export default {
  name: 'MRWidgetPipelineBlocked',
  components: {
    statusIcon,
  },
  template: `
    <div class="mr-widget-body media">
      <status-icon status="warning" :show-disabled-button="true" />
      <div class="media-body space-children">
        <span class="bold">
          此合并请求的流水线已失败。 请重试该作业或推送一个新的提交来修复失败。
        </span>
      </div>
    </div>
  `,
};
