<script>
import editFormButtons from './edit_form_buttons.vue';

export default {
  props: {
    isConfidential: {
      required: true,
      type: Boolean,
    },
    toggleForm: {
      required: true,
      type: Function,
    },
    updateConfidentialAttribute: {
      required: true,
      type: Function,
    },
  },

  components: {
    editFormButtons,
  },
};
</script>

<template>
  <div class="dropdown open">
    <div class="dropdown-menu sidebar-item-warning-message">
      <div>
        <p v-if="!isConfidential">
          您打算启用保密。这意味着只有
          <strong>至少具备“报告者”权限的团队成员</strong>
          才能够查看并发表有关该问题的评论。
        </p>
        <p v-else>
          您打算禁用保密。这意味着
          <strong>所有人</strong>
          都能够查看并发表有关该问题的评论。
        </p>
        <edit-form-buttons
          :is-confidential="isConfidential"
          :toggle-form="toggleForm"
          :update-confidential-attribute="updateConfidentialAttribute"
        />
      </div>
    </div>
  </div>
</template>
