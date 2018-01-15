import emptyStateSVG from 'icons/_mr_widget_empty_state.svg';

export default {
  name: 'MRWidgetNothingToMerge',
  props: {
    mr: {
      type: Object,
      required: true,
    },
  },
  data() {
    return { emptyStateSVG };
  },
  template: `
    <div class="mr-widget-body mr-widget-empty-state">
      <div class="row">
        <div class="artwork col-sm-5 col-sm-push-7 col-xs-12 text-center">
          <span v-html="emptyStateSVG"></span>
        </div>
        <div class="text col-sm-7 col-sm-pull-5 col-xs-12">
          <span>
            合并请求是一个可以让您提出对项目所做的变更，
            并与其他人讨论这些变更的地方。
          </span>
          <p>
            有兴趣者甚至可以通过推送提交做出贡献。
          </p>
          <p>
            没有什么需要从源分支合并到目标分支。
            请推送新的提交或者选择另一个源分支。
          </p>
          <div>
            <a
              v-if="mr.newBlobPath"
              :href="mr.newBlobPath"
              class="btn btn-inverted btn-save">
              创建文件
            </a>
          </div>
        </div>
      </div>
    </div>
  `,
};
