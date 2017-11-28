<script>
  import updateMixin from '../../mixins/update';
  import markdownField from '../../../vue_shared/components/markdown/field.vue';

  export default {
    mixins: [updateMixin],
    props: {
      formState: {
        type: Object,
        required: true,
      },
      markdownPreviewPath: {
        type: String,
        required: true,
      },
      markdownDocsPath: {
        type: String,
        required: true,
      },
      canAttachFile: {
        type: Boolean,
        required: false,
        default: true,
      },
    },
    components: {
      markdownField,
    },
    mounted() {
      this.$refs.textarea.focus();
    },
  };
</script>

<template>
  <div class="common-note-form">
    <label
      class="sr-only"
      for="issue-description">
      描述
    </label>
    <markdown-field
      :markdown-preview-path="markdownPreviewPath"
      :markdown-docs-path="markdownDocsPath"
      :can-attach-file="canAttachFile">
      <textarea
        id="issue-description"
        class="note-textarea js-gfm-input js-autosize markdown-area"
        data-supports-quick-actionss="false"
        aria-label="描述"
        v-model="formState.description"
        ref="textarea"
        slot="textarea"
        placeholder="撰写评论或拖放文件到此处..."
        @keydown.meta.enter="updateIssuable"
        @keydown.ctrl.enter="updateIssuable">
      </textarea>
    </markdown-field>
  </div>
</template>
