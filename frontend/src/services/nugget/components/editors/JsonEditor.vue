<template>
  <div class="fullwidth row col-12 relative-position">
    <div class="fullwidth row col-12 jsoneditor" ref="container"></div>
    <div class="top-right tr">
      <q-btn icon="mdi-close" @click="this.$emit('close')" label="Close"
        ><q-tooltip></q-tooltip
      ></q-btn>
      <q-btn icon="mdi-content-save" @click="onSave()" label="Save JSON"
        ><q-tooltip></q-tooltip
      ></q-btn>
    </div>
  </div>
</template>

<script>
import { defineComponent, ref, computed, onMounted } from "vue";

import JSONEditor from "jsoneditor";
import "jsoneditor/dist/jsoneditor.css";

export default defineComponent({
  name: "JsonEditor",
  props: ["data", "dataCySlug"],
  components: {},
  setup(props) {
    const container = ref(null);
    const options = { mode: "code" };

    const editor = ref(null);

    onMounted(() => {
      editor.value = new JSONEditor(container.value, options);
      editor.value.set(props.data);
    });

    return {
      container,
      props,
      editor,
    };
  },
  methods: {
    async onSave() {
      const currData = this.editor.get();
      this.$emit("save", { newData: currData });
    },
  },
});
</script>

<style scoped>
.jsoneditor {
  width: 500px;
  height: 500px;
  display: flex;
  flex: 1;
}

.tr {
  opacity: 95%;
}
</style>
