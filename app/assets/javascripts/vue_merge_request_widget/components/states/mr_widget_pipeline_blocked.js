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
          流水线被停用。 此合并请求的流水线需要手动操作才能继续。
        </span>
      </div>
    </div>
  `,
};
