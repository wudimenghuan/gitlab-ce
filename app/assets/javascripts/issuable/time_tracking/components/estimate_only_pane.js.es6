/* global Vue */
(() => {
  Vue.component('time-tracking-estimate-only-pane', {
    name: 'time-tracking-estimate-only-pane',
    props: ['timeEstimateHumanReadable'],
    template: `
      <div class='time-tracking-estimate-only-pane'>
        <span class='bold'>预计:</span>
        {{ timeEstimateHumanReadable }}
      </div>
    `,
  });
})();
