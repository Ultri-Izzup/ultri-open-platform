<!-- WARNING!!
The data passed to this component must be sanitized to prevent XSS.
-->

<template>
  <div class="full-width overflow-hidden q-px-md q-py-sm" v-html="data"></div>
</template>

<script>
import { defineComponent } from "vue";

export default defineComponent({
  name: "HtmlBlock",
  components: {},
  props: ["data", "dataCySlug"],
  setup(props) {
    return {};
  },
  methods: {},
});
</script>
