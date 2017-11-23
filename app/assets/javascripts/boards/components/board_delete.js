/* eslint-disable comma-dangle, space-before-function-paren, no-alert */

import Vue from 'vue';

window.gl = window.gl || {};
window.gl.issueBoards = window.gl.issueBoards || {};

gl.issueBoards.BoardDelete = Vue.extend({
  props: {
    list: Object
  },
  methods: {
    deleteBoard () {
      $(this.$el).tooltip('hide');

      if (confirm('您确定要删除这个列表？')) {
        this.list.destroy();
      }
    }
  }
});
