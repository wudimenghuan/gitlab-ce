<script>
import ModalStore from '../../stores/modal_store';
import modalMixin from '../../mixins/modal_mixins';

export default {
  mixins: [modalMixin],
  props: {
    newIssuePath: {
      type: String,
      required: true,
    },
    emptyStateSvg: {
      type: String,
      required: true,
    },
  },
  data() {
    return ModalStore.store;
  },
  computed: {
    contents() {
      const obj = {
        title: "您的项目还没有添加任何的问题。",
        content: `
          问题可以是要讨论的Bug，任务或概念。
          此外，问题是可搜索、可过滤的。
        `,
      };

      if (this.activeTab === 'selected') {
        obj.title = "您还没有选择一个问题";
        obj.content = `
          返回 <strong>未关闭问题</strong> 并选择一些问题
          来增加到看板。
        `;
      }

      return obj;
    },
  },
};
</script>

<template>
  <section class="empty-state d-flex mt-0 h-100">
    <div class="row w-100 my-auto mx-0">
      <div class="col-12 col-md-6 order-md-last">
        <aside class="svg-content d-none d-md-block"><img :src="emptyStateSvg" /></aside>
      </div>
      <div class="col-12 col-md-6 order-md-first">
        <div class="text-content">
          <h4>{{ contents.title }}</h4>
          <p v-html="contents.content"></p>
          <a v-if="activeTab === 'all'" :href="newIssuePath" class="btn btn-success btn-inverted">
            New issue
          </a>
          <button
            v-if="activeTab === 'selected'"
            class="btn btn-default"
            type="button"
            @click="changeTab('all')"
          >
            Open issues
          </button>
        </div>
      </div>
    </div>
  </section>
</template>
