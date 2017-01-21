/* global Vue */
(() => {
  Vue.component('time-tracking-help-state', {
    name: 'time-tracking-help-state',
    props: ['docsUrl'],
    template: `
      <div class='time-tracking-help-state'>
        <div class='time-tracking-info'>
          <h4>使用“/”命令跟踪时间</h4>
          <p>可以在问题描述或者评论中使用“/”命令</p>
          <p>
            <code>/estimate</code>
            将更新预计时间
          </p>
          <p>
            <code>/spend</code>
            将更新总耗费时间。
          </p>
          <a class='btn btn-default learn-more-button' :href='docsUrl'>了解更多</a>
        </div>
      </div>
    `,
  });
})();
