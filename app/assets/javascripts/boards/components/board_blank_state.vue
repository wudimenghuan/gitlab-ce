<script>
/* global ListLabel */
import Cookies from 'js-cookie';
import boardsStore from '../stores/boards_store';

export default {
  data() {
    return {
      predefinedLabels: [
        new ListLabel({ title: 'To Do', color: '#F0AD4E' }),
        new ListLabel({ title: 'Doing', color: '#5CB85C' }),
      ],
    };
  },
  methods: {
    addDefaultLists() {
      this.clearBlankState();

      this.predefinedLabels.forEach((label, i) => {
        boardsStore.addList({
          title: label.title,
          position: i,
          list_type: 'label',
          label: {
            title: label.title,
            color: label.color,
          },
        });
      });

      // Save the labels
      gl.boardService
        .generateDefaultLists()
        .then(res => res.data)
        .then(data => {
          data.forEach(listObj => {
            const list = boardsStore.findList('title', listObj.title);

            list.id = listObj.id;
            list.label.id = listObj.label.id;
            list.getIssues().catch(() => {
              // TODO: handle request error
            });
          });
        })
        .catch(() => {
          boardsStore.removeList(undefined, 'label');
          Cookies.remove('issue_board_welcome_hidden', {
            path: '',
          });
          boardsStore.addBlankState();
        });
    },
    clearBlankState: boardsStore.removeBlankState.bind(boardsStore),
  },
};
</script>

<template>
  <div class="board-blank-state p-3">
    <p>只需点击一下，即可将以下默认列表添加到问题看板：</p>
    <ul class="list-unstyled board-blank-state-list">
      <li v-for="(label, index) in predefinedLabels" :key="index">
        <span
          :style="{ backgroundColor: label.color }"
          class="label-color position-relative d-inline-block rounded"
        >
        </span>
        {{ label.title }}
      </li>
    </ul>
    <p>
      用默认列表将让您能正确并充分地利用您的的问题看板。
    </p>
    <button
      class="btn btn-success btn-inverted btn-block"
      type="button"
      @click.stop="addDefaultLists"
    >
      添加默认列表
    </button>
    <button class="btn btn-default btn-block" type="button" @click.stop="clearBlankState">
      没关系，我将自己创建列表
    </button>
  </div>
</template>
