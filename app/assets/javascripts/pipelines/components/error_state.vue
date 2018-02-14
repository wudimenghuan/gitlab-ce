<script>
export default {
  props: {
    errorStateSvgPath: {
      type: String,
      required: true,
    },
  },
};
</script>

<template>
  <div class="row empty-state js-pipelines-error-state">
    <div class="col-xs-12">
      <div class="svg-content">
        <img :src="errorStateSvgPath"/>
      </div>
    </div>

    <div class="col-xs-12 text-center">
      <div class="text-content">
        <h4>API 获取流水线失败。</h4>
      </div>
    </div>
  </div>
</template>
