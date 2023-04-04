<template>
  <span :style="'font-family: ' + face">{{ txtStr }}</span>
</template>

<script>
import { defineComponent } from "vue";

export default defineComponent({
  name: "FontDisplay",
  props: ["face", "txtStr"],
  setup(props) {
    return {};
  },
});
</script>
