export default {
  name: 'MRWidgetLocked',
  props: {
    mr: { type: Object, required: true },
  },
  template: `
    <div class="mr-widget-body mr-state-locked">
      <span class="state-label">已锁定</span>
      这个合并请求正在合并中， 在这个过程中合并请求将被锁定并无法关闭。
      <i
        class="fa fa-spinner fa-spin"
        aria-hidden="true" />
      <section class="mr-info-list mr-links">
        <div class="legend"></div>
        <p>
          变更将被合并到
          <span class="label-branch">
            <a :href="mr.targetBranchPath">{{mr.targetBranch}}</a>
          </span>
        </p>
      </section>
    </div>
  `,
};
