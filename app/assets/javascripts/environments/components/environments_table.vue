<script>
/**
 * Render environments table.
 */
import EnvironmentTableRowComponent from './environment_item.vue';
import loadingIcon from '../../vue_shared/components/loading_icon.vue';

export default {
  components: {
    'environment-item': EnvironmentTableRowComponent,
    loadingIcon,
  },

  props: {
    environments: {
      type: Array,
      required: true,
      default: () => ([]),
    },

    canReadEnvironment: {
      type: Boolean,
      required: false,
      default: false,
    },

    canCreateDeployment: {
      type: Boolean,
      required: false,
      default: false,
    },
  },

  methods: {
    folderUrl(model) {
      return `${window.location.pathname}/folders/${model.folderName}`;
    },
  },
};
</script>
<template>
  <div class="ci-table" role="grid">
    <div class="gl-responsive-table-row table-row-header" role="row">
      <div class="table-section section-10 environments-name" role="columnheader">
        运行环境
      </div>
      <div class="table-section section-10 environments-deploy" role="columnheader">
        部署
      </div>
      <div class="table-section section-15 environments-build" role="columnheader">
        作业
      </div>
      <div class="table-section section-25 environments-commit" role="columnheader">
        提交
      </div>
      <div class="table-section section-10 environments-date" role="columnheader">
        更新于
      </div>
    </div>
    <template
      v-for="model in environments"
      v-bind:model="model">
      <div
        is="environment-item"
        :model="model"
        :can-create-deployment="canCreateDeployment"
        :can-read-environment="canReadEnvironment"
        />

      <template v-if="model.isFolder && model.isOpen && model.children && model.children.length > 0">
        <div v-if="model.isLoadingFolderContent">
          <loading-icon size="2" />
        </div>

        <template v-else>
          <div
            is="environment-item"
            v-for="children in model.children"
            :model="children"
            :can-create-deployment="canCreateDeployment"
            :can-read-environment="canReadEnvironment"
            />

          <div>
            <div class="text-center prepend-top-10">
              <a
                :href="folderUrl(model)"
                class="btn btn-default">
                全部显示
              </a>
            </div>
          </div>
        </template>
      </template>
    </template>
  </div>
</template>
