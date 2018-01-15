import Flash from '../../../flash';
import statusIcon from '../mr_widget_status_icon';
import MRWidgetAuthor from '../../components/mr_widget_author';
import eventHub from '../../event_hub';

export default {
  name: 'MRWidgetMergeWhenPipelineSucceeds',
  props: {
    mr: { type: Object, required: true },
    service: { type: Object, required: true },
  },
  components: {
    'mr-widget-author': MRWidgetAuthor,
    statusIcon,
  },
  data() {
    return {
      isCancellingAutoMerge: false,
      isRemovingSourceBranch: false,
    };
  },
  computed: {
    canRemoveSourceBranch() {
      const { shouldRemoveSourceBranch, canRemoveSourceBranch,
        mergeUserId, currentUserId } = this.mr;

      return !shouldRemoveSourceBranch && canRemoveSourceBranch && mergeUserId === currentUserId;
    },
  },
  methods: {
    cancelAutomaticMerge() {
      this.isCancellingAutoMerge = true;
      this.service.cancelAutomaticMerge()
        .then(res => res.data)
        .then((data) => {
          eventHub.$emit('UpdateWidgetData', data);
        })
        .catch(() => {
          this.isCancellingAutoMerge = false;
          new Flash('出现错误，请稍后重试。'); // eslint-disable-line
        });
    },
    removeSourceBranch() {
      const options = {
        sha: this.mr.sha,
        merge_when_pipeline_succeeds: true,
        should_remove_source_branch: true,
      };

      this.isRemovingSourceBranch = true;
      this.service.mergeResource.save(options)
        .then(res => res.data)
        .then((data) => {
          if (data.status === 'merge_when_pipeline_succeeds') {
            eventHub.$emit('MRWidgetUpdateRequested');
          }
        })
        .catch(() => {
          this.isRemovingSourceBranch = false;
          new Flash('出现错误，请稍后重试。'); // eslint-disable-line
        });
    },
  },
  template: `
    <div class="mr-widget-body media">
      <status-icon status="success" />
      <div class="media-body">
        <h4 class="flex-container-block">
          <span class="append-right-10">
            设置为
            <mr-widget-author :author="mr.setToMWPSBy" />
            当流水线成功后自动合并
          </span>
          <a
            v-if="mr.canCancelAutomaticMerge"
            @click.prevent="cancelAutomaticMerge"
            :disabled="isCancellingAutoMerge"
            role="button"
            href="#"
            class="btn btn-xs btn-default js-cancel-auto-merge">
            <i
              v-if="isCancellingAutoMerge"
              class="fa fa-spinner fa-spin"
              aria-hidden="true" />
              取消自动合并
          </a>
        </h4>
        <section class="mr-info-list">
          <p>变更将会合并到
            <a
              :href="mr.targetBranchPath"
              class="label-branch">
              {{mr.targetBranch}}
            </a>
          </p>
          <p v-if="mr.shouldRemoveSourceBranch">
            源分支将被删除
          </p>
          <p
            v-else
            class="flex-container-block"
          >
            <span class="append-right-10">
              源分支将不会被删除
            </span>
            <a
              v-if="canRemoveSourceBranch"
              :disabled="isRemovingSourceBranch"
              @click.prevent="removeSourceBranch"
              role="button"
              class="btn btn-xs btn-default js-remove-source-branch"
              href="#">
              <i
              v-if="isRemovingSourceBranch"
              class="fa fa-spinner fa-spin"
              aria-hidden="true" />
              删除源分支
            </a>
          </p>
        </section>
      </div>
    </div>
  `,
};
