import Vue from 'vue';

const ModalStore = gl.issueBoards.ModalStore;

gl.issueBoards.ModalEmptyState = Vue.extend({
  mixins: [gl.issueBoards.ModalMixins],
  data() {
    return ModalStore.store;
  },
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
  computed: {
    contents() {
      const obj = {
        title: '您的项目还没有添加任何的问题。',
        content: `
          问题可以是要讨论的Bug，任务或概念。
          此外，问题是可搜索、可过滤的。
        `,
      };

      if (this.activeTab === 'selected') {
        obj.title = '您还没有选择一个问题';
        obj.content = `
          返回 <strong>未关闭问题</strong> 并选择一些问题
          来增加到看板。
        `;
      }

      return obj;
    },
  },
  template: `
    <section class="empty-state">
      <div class="row">
        <div class="col-xs-12 col-sm-6 col-sm-push-6">
          <aside class="svg-content"><img :src="emptyStateSvg"/></aside>
        </div>
        <div class="col-xs-12 col-sm-6 col-sm-pull-6">
          <div class="text-content">
            <h4>{{ contents.title }}</h4>
            <p v-html="contents.content"></p>
            <a
              :href="newIssuePath"
              class="btn btn-success btn-inverted"
              v-if="activeTab === 'all'">
              新建问题
            </a>
            <button
              type="button"
              class="btn btn-default"
              @click="changeTab('all')"
              v-if="activeTab === 'selected'">
              未关闭问题
            </button>
          </div>
        </div>
      </div>
    </section>
  `,
});
