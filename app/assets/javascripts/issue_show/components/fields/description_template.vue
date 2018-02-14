<script>
  import IssuableTemplateSelectors from '../../../templates/issuable_template_selectors';

  export default {
    props: {
      formState: {
        type: Object,
        required: true,
      },
      issuableTemplates: {
        type: Array,
        required: false,
        default: () => [],
      },
      projectPath: {
        type: String,
        required: true,
      },
      projectNamespace: {
        type: String,
        required: true,
      },
    },
    computed: {
      issuableTemplatesJson() {
        return JSON.stringify(this.issuableTemplates);
      },
    },
    mounted() {
      // Create the editor for the template
      const editor = document.querySelector('.detail-page-description .note-textarea') || {};
      editor.setValue = (val) => {
        this.formState.description = val;
      };
      editor.getValue = () => this.formState.description;

      this.issuableTemplate = new IssuableTemplateSelectors({
        $dropdowns: $(this.$refs.toggle),
        editor,
      });
    },
  };
</script>

<template>
  <div
    class="dropdown js-issuable-selector-wrap"
    data-issuable-type="issue">
    <button
      class="dropdown-menu-toggle js-issuable-selector"
      type="button"
      ref="toggle"
      data-field-name="issuable_template"
      data-selected="null"
      data-toggle="dropdown"
      :data-namespace-path="projectNamespace"
      :data-project-path="projectPath"
      :data-data="issuableTemplatesJson">
      <span class="dropdown-toggle-text">
        选择模板
      </span>
      <i
        aria-hidden="true"
        class="fa fa-chevron-down">
      </i>
    </button>
    <div class="dropdown-menu dropdown-select">
      <div class="dropdown-title">
        选择模板
        <button
          class="dropdown-title-button dropdown-menu-close"
          aria-label="关闭"
          type="button">
          <i
            aria-hidden="true"
            class="fa fa-times dropdown-menu-close-icon">
          </i>
        </button>
      </div>
      <div class="dropdown-input">
        <input
          type="search"
          class="dropdown-input-field"
          placeholder="过滤"
          autocomplete="off" />
        <i
          aria-hidden="true"
          class="fa fa-search dropdown-input-search">
        </i>
        <i
          role="button"
          aria-label="清除模板搜索输入"
          class="fa fa-times dropdown-input-clear js-dropdown-input-clear">
        </i>
      </div>
      <div class="dropdown-content"></div>
      <div class="dropdown-footer">
        <ul class="dropdown-footer-list">
          <li>
            <a class="no-template">
              没有模板
            </a>
          </li>
          <li>
            <a class="reset-template">
              重置模板
            </a>
          </li>
        </ul>
      </div>
    </div>
  </div>
</template>
