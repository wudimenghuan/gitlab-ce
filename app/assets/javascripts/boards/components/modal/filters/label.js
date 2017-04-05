/* eslint-disable no-new */
/* global Vue */
/* global LabelsSelect */
module.exports = Vue.extend({
  name: 'filter-label',
  props: {
    labelPath: {
      type: String,
      required: true,
    },
  },
  mounted() {
    new LabelsSelect(this.$refs.dropdown);
  },
  template: `
    <div class="dropdown">
      <button
        class="dropdown-menu-toggle js-label-select js-multiselect js-extra-options"
        type="button"
        data-toggle="dropdown"
        data-show-any="true"
        data-show-no="true"
        :data-labels="labelPath"
        ref="dropdown">
        <span class="dropdown-toggle-text">
          标记
        </span>
        <i class="fa fa-chevron-down"></i>
      </button>
      <div class="dropdown-menu dropdown-select dropdown-menu-paging dropdown-menu-labels dropdown-menu-selectable">
        <div class="dropdown-title">
          按标记过滤
          <button
            class="dropdown-title-button dropdown-menu-close"
            aria-label="关闭"
            type="button">
            <i class="fa fa-times dropdown-menu-close-icon"></i>
          </button>
        </div>
        <div class="dropdown-input">
          <input
            type="search"
            class="dropdown-input-field"
            placeholder="搜索"
            autocomplete="off" />
          <i class="fa fa-search dropdown-input-search"></i>
          <i role="button" class="fa fa-times dropdown-input-clear js-dropdown-input-clear"></i>
        </div>
        <div class="dropdown-content"></div>
        <div class="dropdown-loading"><i class="fa fa-spinner fa-spin"></i></div>
      </div>
    </div>
  `,
});
