import statusIcon from '../mr_widget_status_icon';

export default {
  name: 'MRWidgetSHAMismatch',
  components: {
    statusIcon,
  },
  template: `
    <div class="mr-widget-body media">
      <status-icon status="warning" :show-disabled-button="true" />
      <div class="media-body space-children">
        <span class="bold">
          源分支的 HEAD 在最近发生了变更。 请重新加载页面，并在合并之前查看更改。
        </span>
      </div>
    </div>
  `,
};
