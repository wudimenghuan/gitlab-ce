import statusIcon from '../mr_widget_status_icon';

export default {
  name: 'MRWidgetArchived',
  components: {
    statusIcon,
  },
  template: `
    <div class="mr-widget-body media">
      <div class="space-children">
        <status-icon status="failed" />
        <button
          type="button"
          class="btn btn-success btn-sm"
          disabled="true">
          合并
        </button>
      </div>
      <div class="media-body">
        <span class="bold">
          这个项目已归档，写入权限被禁用。
        </span>
      </div>
    </div>
  `,
};
