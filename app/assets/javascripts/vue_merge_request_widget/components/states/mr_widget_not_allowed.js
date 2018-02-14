import statusIcon from '../mr_widget_status_icon.vue';

export default {
  name: 'MRWidgetNotAllowed',
  components: {
    statusIcon,
  },
  template: `
    <div class="mr-widget-body media">
      <status-icon status="success" :show-disabled-button="true" />
      <div class="media-body space-children">
        <span class="bold">
          已准备好自动合并。
          请询问具有此仓库写权限的成员来合并此请求。
        </span>
      </div>
    </div>
  `,
};
