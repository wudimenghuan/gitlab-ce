<script>
import projectFeatureSetting from './project_feature_setting.vue';
import projectFeatureToggle from '../../../vue_shared/components/toggle_button.vue';
import projectSettingRow from './project_setting_row.vue';
import { visibilityOptions, visibilityLevelDescriptions } from '../constants';
import { toggleHiddenClassBySelector } from '../external';

export default {
  props: {
    currentSettings: {
      type: Object,
      required: true,
    },
    canChangeVisibilityLevel: {
      type: Boolean,
      required: false,
      default: false,
    },
    allowedVisibilityOptions: {
      type: Array,
      required: false,
      default: () => [0, 10, 20],
    },
    lfsAvailable: {
      type: Boolean,
      required: false,
      default: false,
    },
    registryAvailable: {
      type: Boolean,
      required: false,
      default: false,
    },
    visibilityHelpPath: {
      type: String,
      required: false,
    },
    lfsHelpPath: {
      type: String,
      required: false,
    },
    registryHelpPath: {
      type: String,
      required: false,
    },
  },

  data() {
    const defaults = {
      visibilityOptions,
      visibilityLevel: visibilityOptions.PUBLIC,
      issuesAccessLevel: 20,
      repositoryAccessLevel: 20,
      mergeRequestsAccessLevel: 20,
      buildsAccessLevel: 20,
      wikiAccessLevel: 20,
      snippetsAccessLevel: 20,
      containerRegistryEnabled: true,
      lfsEnabled: true,
      requestAccessEnabled: true,
      highlightChangesClass: false,
    };

    return { ...defaults, ...this.currentSettings };
  },

  components: {
    projectFeatureSetting,
    projectFeatureToggle,
    projectSettingRow,
  },

  computed: {
    featureAccessLevelOptions() {
      const options = [
        [10, '只有项目成员'],
      ];
      if (this.visibilityLevel !== visibilityOptions.PRIVATE) {
        options.push([20, '任何人都可以访问']);
      }
      return options;
    },

    repoFeatureAccessLevelOptions() {
      return this.featureAccessLevelOptions.filter(
        ([value]) => value <= this.repositoryAccessLevel,
      );
    },

    repositoryEnabled() {
      return this.repositoryAccessLevel > 0;
    },

    visibilityLevelDescription() {
      return visibilityLevelDescriptions[this.visibilityLevel];
    },
  },

  methods: {
    highlightChanges() {
      this.highlightChangesClass = true;
      this.$nextTick(() => {
        this.highlightChangesClass = false;
      });
    },

    visibilityAllowed(option) {
      return this.allowedVisibilityOptions.includes(option);
    },
  },

  watch: {
    visibilityLevel(value, oldValue) {
      if (value === visibilityOptions.PRIVATE) {
        // when private, features are restricted to "only team members"
        this.issuesAccessLevel = Math.min(10, this.issuesAccessLevel);
        this.repositoryAccessLevel = Math.min(10, this.repositoryAccessLevel);
        this.mergeRequestsAccessLevel = Math.min(10, this.mergeRequestsAccessLevel);
        this.buildsAccessLevel = Math.min(10, this.buildsAccessLevel);
        this.wikiAccessLevel = Math.min(10, this.wikiAccessLevel);
        this.snippetsAccessLevel = Math.min(10, this.snippetsAccessLevel);
        this.highlightChanges();
      } else if (oldValue === visibilityOptions.PRIVATE) {
        // if changing away from private, make enabled features more permissive
        if (this.issuesAccessLevel > 0) this.issuesAccessLevel = 20;
        if (this.repositoryAccessLevel > 0) this.repositoryAccessLevel = 20;
        if (this.mergeRequestsAccessLevel > 0) this.mergeRequestsAccessLevel = 20;
        if (this.buildsAccessLevel > 0) this.buildsAccessLevel = 20;
        if (this.wikiAccessLevel > 0) this.wikiAccessLevel = 20;
        if (this.snippetsAccessLevel > 0) this.snippetsAccessLevel = 20;
        this.highlightChanges();
      }
    },

    repositoryAccessLevel(value, oldValue) {
      if (value < oldValue) {
        // sub-features cannot have more premissive access level
        this.mergeRequestsAccessLevel = Math.min(this.mergeRequestsAccessLevel, value);
        this.buildsAccessLevel = Math.min(this.buildsAccessLevel, value);

        if (value === 0) {
          this.containerRegistryEnabled = false;
          this.lfsEnabled = false;
        }
      } else if (oldValue === 0) {
        this.mergeRequestsAccessLevel = value;
        this.buildsAccessLevel = value;
        this.containerRegistryEnabled = true;
        this.lfsEnabled = true;
      }
    },

    issuesAccessLevel(value, oldValue) {
      if (value === 0) toggleHiddenClassBySelector('.issues-feature', true);
      else if (oldValue === 0) toggleHiddenClassBySelector('.issues-feature', false);
    },

    mergeRequestsAccessLevel(value, oldValue) {
      if (value === 0) toggleHiddenClassBySelector('.merge-requests-feature', true);
      else if (oldValue === 0) toggleHiddenClassBySelector('.merge-requests-feature', false);
    },

    buildsAccessLevel(value, oldValue) {
      if (value === 0) toggleHiddenClassBySelector('.builds-feature', true);
      else if (oldValue === 0) toggleHiddenClassBySelector('.builds-feature', false);
    },
  },
};

</script>

<template>
  <div>
    <div class="project-visibility-setting">
      <project-setting-row
        label="项目可见性"
        :help-path="visibilityHelpPath"
      >
        <div class="project-feature-controls">
          <div class="select-wrapper">
            <select
              name="project[visibility_level]"
              v-model="visibilityLevel"
              class="form-control select-control"
              :disabled="!canChangeVisibilityLevel"
            >
              <option
                :value="visibilityOptions.PRIVATE"
                :disabled="!visibilityAllowed(visibilityOptions.PRIVATE)"
              >
                私有
              </option>
              <option
                :value="visibilityOptions.INTERNAL"
                :disabled="!visibilityAllowed(visibilityOptions.INTERNAL)"
              >
                内部
              </option>
              <option
                :value="visibilityOptions.PUBLIC"
                :disabled="!visibilityAllowed(visibilityOptions.PUBLIC)"
              >
                公共
              </option>
            </select>
            <i aria-hidden="true" data-hidden="true" class="fa fa-chevron-down"></i>
          </div>
        </div>
        <span class="help-block">{{ visibilityLevelDescription }}</span>
        <label v-if="visibilityLevel !== visibilityOptions.PRIVATE" class="request-access">
          <input
            type="hidden"
            name="project[request_access_enabled]"
            :value="requestAccessEnabled"
          />
          <input type="checkbox" v-model="requestAccessEnabled" />
          允许用户请求访问
        </label>
      </project-setting-row>
    </div>
    <div class="project-feature-settings" :class="{ 'highlight-changes': highlightChangesClass }">
      <project-setting-row
        label="问题"
        help-text="轻量级问题跟踪系统"
      >
        <project-feature-setting
          name="project[project_feature_attributes][issues_access_level]"
          :options="featureAccessLevelOptions"
          v-model="issuesAccessLevel"
        />
      </project-setting-row>
      <project-setting-row
        label="版本库"
        help-text="查看和编辑本项目的文件"
      >
        <project-feature-setting
          name="project[project_feature_attributes][repository_access_level]"
          :options="featureAccessLevelOptions"
          v-model="repositoryAccessLevel"
        />
      </project-setting-row>
      <div class="project-feature-setting-group">
        <project-setting-row
          label="合并请求"
          help-text="提交更改以在上游合并"
        >
          <project-feature-setting
            name="project[project_feature_attributes][merge_requests_access_level]"
            :options="repoFeatureAccessLevelOptions"
            v-model="mergeRequestsAccessLevel"
            :disabledInput="!repositoryEnabled"
          />
        </project-setting-row>
        <project-setting-row
          label="流水线"
          help-text="构建、测试并部署您的变更"
        >
          <project-feature-setting
            name="project[project_feature_attributes][builds_access_level]"
            :options="repoFeatureAccessLevelOptions"
            v-model="buildsAccessLevel"
            :disabledInput="!repositoryEnabled"
          />
        </project-setting-row>
        <project-setting-row
          v-if="registryAvailable"
          label="容器注册表"
          :help-path="registryHelpPath"
          help-text="每个项目都可以有自己的空间来存储其 Docker 镜像"
        >
          <project-feature-toggle
            name="project[container_registry_enabled]"
            v-model="containerRegistryEnabled"
            :disabledInput="!repositoryEnabled"
          />
        </project-setting-row>
        <project-setting-row
          v-if="lfsAvailable"
          label="Git 大文件存储(LFS)"
          :help-path="lfsHelpPath"
          help-text="管理大型文件，如音频，视频和图形文件。"
        >
          <project-feature-toggle
            name="project[lfs_enabled]"
            v-model="lfsEnabled"
            :disabledInput="!repositoryEnabled"
          />
        </project-setting-row>
      </div>
      <project-setting-row
        label="维基"
        help-text="项目文档页面"
      >
        <project-feature-setting
          name="project[project_feature_attributes][wiki_access_level]"
          :options="featureAccessLevelOptions"
          v-model="wikiAccessLevel"
        />
      </project-setting-row>
      <project-setting-row
        label="代码片段"
        help-text="共享 git 版本仓库外的代码"
      >
        <project-feature-setting
          name="project[project_feature_attributes][snippets_access_level]"
          :options="featureAccessLevelOptions"
          v-model="snippetsAccessLevel"
        />
      </project-setting-row>
    </div>
  </div>
</template>
