export default {
  name: 'AssigneeTitle',
  props: {
    loading: {
      type: Boolean,
      required: false,
      default: false,
    },
    numberOfAssignees: {
      type: Number,
      required: true,
    },
    editable: {
      type: Boolean,
      required: true,
    },
  },
  computed: {
    assigneeTitle() {
      const assignees = this.numberOfAssignees;
      return assignees > 1 ? `${assignees} 个指派` : '个指派';
    },
  },
  template: `
    <div class="title hide-collapsed">
      {{assigneeTitle}}
      <i
        v-if="loading"
        aria-hidden="true"
        class="fa fa-spinner fa-spin block-loading"
      />
      <a
        v-if="editable"
        class="edit-link pull-right"
        href="#"
      >
        编辑
      </a>
    </div>
  `,
};
