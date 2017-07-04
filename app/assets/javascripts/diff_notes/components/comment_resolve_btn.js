/* eslint-disable comma-dangle, object-shorthand, func-names, no-else-return, quotes, no-lonely-if, max-len */
/* global CommentsStore */

import Vue from 'vue';

const CommentAndResolveBtn = Vue.extend({
  props: {
    discussionId: String,
  },
  data() {
    return {
      textareaIsEmpty: true,
      discussion: {},
    };
  },
  computed: {
    showButton: function () {
      if (this.discussion) {
        return this.discussion.isResolvable();
      } else {
        return false;
      }
    },
    isDiscussionResolved: function () {
      return this.discussion.isResolved();
    },
    buttonText: function () {
      if (this.isDiscussionResolved) {
        if (this.textareaIsEmpty) {
          return "未解决讨论";
        } else {
          return "评论 & 未解决讨论";
        }
      } else {
        if (this.textareaIsEmpty) {
          return "解决讨论";
        } else {
          return "评论 & 解决讨论";
        }
      }
    }
  },
  created() {
    if (this.discussionId) {
      this.discussion = CommentsStore.state[this.discussionId];
    }
  },
  mounted: function () {
    if (!this.discussionId) return;

    const $textarea = $(`.js-discussion-note-form[data-discussion-id=${this.discussionId}] .note-textarea`);
    this.textareaIsEmpty = $textarea.val() === '';

    $textarea.on('input.comment-and-resolve-btn', () => {
      this.textareaIsEmpty = $textarea.val() === '';
    });
  },
  destroyed: function () {
    if (!this.discussionId) return;

    $(`.js-discussion-note-form[data-discussion-id=${this.discussionId}] .note-textarea`).off('input.comment-and-resolve-btn');
  }
});

Vue.component('comment-and-resolve-btn', CommentAndResolveBtn);
