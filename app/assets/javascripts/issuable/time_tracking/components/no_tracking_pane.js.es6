/* global Vue */
(() => {
  Vue.component('time-tracking-no-tracking-pane', {
    name: 'time-tracking-no-tracking-pane',
    template: `
      <div class='time-tracking-no-tracking-pane'>
        <span class='no-value'>没有预估或者已耗费工时</span>
      </div>
    `,
  });
})();
