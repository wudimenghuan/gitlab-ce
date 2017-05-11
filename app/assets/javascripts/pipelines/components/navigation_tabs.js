export default {
  props: {
    scope: {
      type: String,
      required: true,
    },

    count: {
      type: Object,
      required: true,
    },

    paths: {
      type: Object,
      required: true,
    },
  },

  mounted() {
    $(document).trigger('init.scrolling-tabs');
  },

  template: `
    <ul class="nav-links scrolling-tabs">
      <li
        class="js-pipelines-tab-all"
        :class="{ 'active': scope === 'all'}">
        <a :href="paths.allPath">
          全部
          <span class="badge js-totalbuilds-count">
            {{count.all}}
          </span>
        </a>
      </li>
      <li class="js-pipelines-tab-pending"
        :class="{ 'active': scope === 'pending'}">
        <a :href="paths.pendingPath">
          排队中
          <span class="badge">
            {{count.pending}}
          </span>
        </a>
      </li>
      <li class="js-pipelines-tab-running"
        :class="{ 'active': scope === 'running'}">
        <a :href="paths.runningPath">
          正在运行
          <span class="badge">
            {{count.running}}
          </span>
        </a>
      </li>
      <li class="js-pipelines-tab-finished"
        :class="{ 'active': scope === 'finished'}">
        <a :href="paths.finishedPath">
          已完成
          <span class="badge">
            {{count.finished}}
          </span>
        </a>
      </li>
      <li class="js-pipelines-tab-branches"
      :class="{ 'active': scope === 'branches'}">
        <a :href="paths.branchesPath">分支</a>
      </li>
      <li class="js-pipelines-tab-tags"
        :class="{ 'active': scope === 'tags'}">
        <a :href="paths.tagsPath">标签</a>
      </li>
    </ul>
  `,
};
