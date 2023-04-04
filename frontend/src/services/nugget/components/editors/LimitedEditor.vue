<template>
  <div class="col-12">
    <!-- Allow Limited HTML content creation using the Quasar QEditor -->
    <q-editor
      class="full-width"
      v-model="editorData"
      :dense="$q.screen.lt.md"
      :toolbar="[
        ['bold', 'italic', 'strike'],
        [
          {
            label: $q.lang.editor.formatting,
            icon: $q.iconSet.editor.formatting,
            list: 'no-icons',
            options: ['p', 'code'],
          },
          {
            label: $q.lang.editor.fontSize,
            icon: $q.iconSet.editor.fontSize,
            fixedLabel: true,
            fixedIcon: true,
            list: 'no-icons',
            options: ['size-2', 'size-3', 'size-4'],
          },
          {
            label: $q.lang.editor.defaultFont,
            icon: $q.iconSet.editor.font,
            fixedIcon: true,
            list: 'no-icons',
            options: ['arial', 'arial_black'],
          },
          'removeFormat',
        ],
        ['quote', 'unordered', 'ordered'],

        ['undo', 'redo'],
      ]"
      :fonts="{
        arial: 'Arial',
        arial_black: 'Arial Black',
      }"
    ></q-editor>

    <!-- Control buttons -->
    <div class="row col-12">
      <!--
      <q-space></q-space>
      <q-btn
        @click="this.clear()"
        class="subdued-btn"
        icon-right="mdi-sync"
        flat
        size="sm"
        label="Clear"
        :disabled="!dirtyBit"
        :data-cy="dataCySlug + '-clear-btn'"
      ></q-btn>
      <q-btn
        @click="
          this.$emit('save', { newData: editorData });
          this.dirtyBit = false;
        "
        class="option-btn"
        icon="save"
        size="sm"
        :disabled="!dirtyBit"
        label="Save"
        :data-cy="dataCySlug + '-save-btn'"
      ></q-btn>
      -->
      <q-space></q-space>
      <q-btn
        @click="emit('close')"
        class="subdued-btn"
        icon-right="mdi-close"
        flat
        size="sm"
        label="Close"
        :data-cy="dataCySlug + '-close-btn'"
      ></q-btn>
    </div>
  </div>
</template>

<script setup>
import { unref, watch, ref } from "vue";
import { useQuasar } from "quasar";

const props = defineProps({
  data: {
    type: [String, null],
  },
  dataCySlug: {
    type: String,
  },
});

const emit = defineEmits(["save", "close"]);

const $q = useQuasar();

let rawData = "";

if (props.data) {
  rawData = unref(props.data);
}

const editorData = ref(rawData);

watch(editorData, (value) => {
  if (value) {
    // dirtyBit.value = true;
    emit("save", { newData: editorData.value });
  }
});
</script>

<style lang="scss"></style>
