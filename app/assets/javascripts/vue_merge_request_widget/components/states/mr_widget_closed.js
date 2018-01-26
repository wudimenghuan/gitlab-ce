import mrWidgetAuthorTime from '../../components/mr_widget_author_time';
import statusIcon from '../mr_widget_status_icon';

export default {
  name: 'MRWidgetClosed',
  props: {
    mr: { type: Object, required: true },
  },
  components: {
    'mr-widget-author-and-time': mrWidgetAuthorTime,
    statusIcon,
  },
  template: `
    <div class="mr-widget-body media">
      <status-icon status="warning" />
      <div class="media-body">
        <mr-widget-author-and-time
          actionText="关闭者"
          :author="mr.metrics.closedBy"
          :dateTitle="mr.metrics.closedAt"
          :dateReadable="mr.metrics.readableClosedAt"
        />
        <section class="mr-info-list">
          <p>
            变更无法合并到
            <a
              :href="mr.targetBranchPath"
              class="label-branch">
              {{mr.targetBranch}}</a>
          </p>
        </section>
      </div>
    </div>
  `,
};
