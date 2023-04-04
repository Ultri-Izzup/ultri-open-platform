<template>
  <!-- Component div -->
  <div class="row col-12 q-my-sm">
    <!-- Display separator with live updates -->
    <div
      :class="
        'row col-12 q-pt-' +
        editorData.padTop +
        ' q-pb-' +
        editorData.padBot +
        ' q-px-' +
        editorData.padSides
      "
    >
      <q-separator
        :color="selectedColor"
        :size="editorData.size"
        class="col-12"
        spaced="q-ma-lg"
      ></q-separator>
    </div>
  </div>
  <div class="row col-12 q-pa-md">
    <div class="row col-12 q-mt-lg">
      <div class="row col-12 q-pa-xs">
        <div class="col-7">Pad Top:</div>
        <div class="col-5">
          <q-select
            filled
            v-model="editorData.padTop"
            :options="paddingOptions"
            emit-value
            map-options
            dense
            options-dense
          ></q-select>
        </div>
      </div>
      <div class="row col-12 q-pa-xs">
        <div class="col-7">Pad Bottom:</div>
        <div class="col-5">
          <q-select
            filled
            v-model="editorData.padBot"
            :options="paddingOptions"
            emit-value
            map-options
            dense
            options-dense
          ></q-select>
        </div>
      </div>
      <div class="row col-12 q-pa-xs">
        <div class="col-7">Pad Sides:</div>
        <div class="col-5">
          <q-select
            filled
            v-model="editorData.padSides"
            :options="paddingOptions"
            emit-value
            map-options
            dense
            options-dense
          ></q-select>
        </div>
      </div>

      <div class="row col-12 q-pa-xs">
        <div class="col-7">Size:</div>
        <div class="col-5">
          <q-select
            filled
            v-model="editorData.size"
            :options="sizeOptions"
            emit-value
            map-options
            dense
            options-dense
          ></q-select>
        </div>
      </div>

      <div class="row col-12 q-pa-xs">
        <div class="col-7">Color:</div>
        <div class="col-5">
          <q-select
            filled
            v-model="editorData.color"
            :options="baseColors"
            dense
            options-dense
          ></q-select>
        </div>
      </div>

      <div class="row col-12 q-pa-xs">
        <div class="col-7">Color Shade:</div>
        <div class="col-5">
          <q-select
            filled
            v-model="editorData.colorVar"
            :options="colorVars"
            dense
            options-dense
          ></q-select>
        </div>
      </div>
    </div>

    <!-- Control buttons -->
    <div class="row col-12">
      <q-space></q-space>
      <q-btn
        @click="emit('close')"
        class="subdued-btn"
        icon-right="mdi-close"
        flat
        size="sm"
        label="Close"
        :disabled="!closeEnabled"
      ></q-btn>
    </div>
  </div>
</template>

<script setup>
import { ref, watch, reactive, computed } from "vue";

const props = defineProps({
  data: {
    type: [Object, null],
  },
  dataCySlug: {
    type: String,
    default: "img",
  },
});

const emit = defineEmits(["save", "close"]);

const paddingOptions = [
  {
    label: "X-Small",
    value: "xs",
  },

  {
    label: "Small",
    value: "sm",
  },
  {
    label: "Medium",
    value: "md",
  },
  {
    label: "Large",
    value: "lg",
  },
  {
    label: "X-Large",
    value: "xl",
  },
];

const sizeOptions = [
  {
    label: "X-Small",
    value: ".2em",
  },

  {
    label: "Small",
    value: ".5em",
  },
  {
    label: "Medium",
    value: "1em",
  },
  {
    label: "Large",
    value: "2em",
  },
  {
    label: "X-Large",
    value: "4em",
  },
];

const baseColors = [
  "red",
  "pink",
  "purple",
  "deep-purple",
  "indigo",
  "blue",
  "light-blue",
  "cyan",
  "teal",
  "green",
  "light-green",
  "lime",
  "yellow",
  "amber",
  "orange",
  "deep-orange",
  "brown",
  "grey",
  "blue-grey",
];

const colorVars = [
  "1",
  "2",
  "3",
  "4",
  "5",
  "6",
  "7",
  "8",
  "9",
  "10",
  "11",
  "12",
  "13",
  "14",
];

let rawData = {
  padTop: "xs",
  padBot: "xs",
  padSides: "md",
  size: ".2em",
  color: "green",
  colorVar: "4",
};

if (props.data) {
  rawData = { ...props.data };
} else {
  emit("save", rawData);
}

const editorData = reactive(rawData);

const clear = () => {
  Object.assign(editorData, props.data);
};

// Use the dirty bit to track if changes have been made
const dirtyBit = ref(false);

const selectedColor = computed(() => {
  return editorData.color + "-" + editorData.colorVar;
});

const closeEnabled = computed(() => {
  return !dirtyBit.value ? true : false;
});

watch(editorData, (value) => {
  if (value) {
    // dirtyBit.value = true;
    emit("save", { newData: value });
  }
});
</script>

<style></style>
