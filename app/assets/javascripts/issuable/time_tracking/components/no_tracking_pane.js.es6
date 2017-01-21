/* global Vue */
(() => {
  Vue.component('time-tracking-no-tracking-pane', {
    name: 'time-tracking-no-tracking-pane',
    template: `
      <div class='time-tracking-no-tracking-pane'>
        <span class='no-value'>没有预计或者耗费时间</span>
      </div>
    `,
  });
})();
