/* global Vue */
(() => {
  Vue.component('time-tracking-spent-only-pane', {
    name: 'time-tracking-spent-only-pane',
    props: ['timeSpentHumanReadable'],
    template: `
      <div class='time-tracking-spend-only-pane'>
        <span class='bold'>耗费:</span>
        {{ timeSpentHumanReadable }}
      </div>
    `,
  });
})();
