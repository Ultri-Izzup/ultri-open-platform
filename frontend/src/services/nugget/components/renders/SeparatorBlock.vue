<!-- WARNING!!
The data passed to this component must be sanitized to prevent XSS.
-->
<template>
  <div class="row col-12 q-pa-md fit">
    <div v-if="data" class="row col-12">
      <!-- Display separator with live updates -->
      <div
        :class="
          'row col-12 q-pt-' +
          data.padTop +
          ' q-pb-' +
          data.padBot +
          ' q-px-' +
          data.padSides
        "
      >
        <q-separator
          :color="data.color + '-' + data.colorVar"
          :size="data.size"
          class="col-12"
          spaced="q-ma-lg"
        ></q-separator>
      </div>
    </div>
  </div>
</template>

<script setup>
import { computed } from "vue";

let defaultData = {
  padTop: "xs",
  padBot: "xs",
  padSides: "md",
  size: ".2em",
  color: "green",
  colorVar: "4",
};

const props = defineProps({
  data: {
    type: [Object, null],
    default: () => {
      return {
        padTop: "xs",
        padBot: "xs",
        padSides: "md",
        size: ".2em",
        color: "green",
        colorVar: "4",
      };
    },
  },
  dataCySlug: {
    type: String,
    default: "separator",
  },
});
</script>
