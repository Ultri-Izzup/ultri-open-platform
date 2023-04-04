<!--
  Blocks are a sequenced list of objects defining the content of a Page (article|story|blog|sitepage).

  The Blocks Editor takes a `blocks` property and exports
-->

<template>
  <div class="row col-12 q-pa-sm">
    <div
      v-for="(block, ix) in editorBlocks"
      :key="ix"
      class="row col-12 block-container"
    >
      <div class="col-12">
        <!-- RENDERS -->
        <div v-show="!isInEdit(block.id)" class="row col-12">
          <div class="col-1 column text-center justify-center items-center">
            <q-btn-dropdown
              flat
              dropdown-icon="mdi-dots-vertical"
              dense
              class="without-arrow"
            >
              <q-list>
                <q-item
                  clickable
                  v-close-popup
                  @click="moveUp(ix)"
                  :disable="ix == 0"
                >
                  <q-item-section avatar>
                    <q-icon name="mdi-arrow-up-bold"></q-icon>
                  </q-item-section>
                  <q-item-section>
                    <q-item-label>Up</q-item-label>
                  </q-item-section>
                </q-item>

                <q-item
                  clickable
                  v-close-popup
                  @click="moveDown(ix)"
                  :disable="ix == editorBlocks.length - 1"
                >
                  <q-item-section avatar>
                    <q-icon name="mdi-arrow-down-bold"></q-icon>
                  </q-item-section>
                  <q-item-section>
                    <q-item-label> Down</q-item-label>
                  </q-item-section>
                </q-item>

                <q-item clickable v-close-popup @click="deleteBlock(block.id)">
                  <q-item-section avatar>
                    <q-icon name="mdi-delete"></q-icon>
                  </q-item-section>
                  <q-item-section>
                    <q-item-label>Delete</q-item-label>
                  </q-item-section>
                </q-item>
              </q-list>
            </q-btn-dropdown>
          </div>
          <div class="column col-11">
            <component
              :is="comps[getRenderer(block.type)]"
              :data="block.data"
              @click="openEditor(block.id)"
              :dataCySlug="'block-render-' + ix"
            ></component>
          </div>
        </div>

        <!-- EDITORS -->
        <div v-show="isInEdit(block.id)" class="row col-12 column">
          <div class="row col-12">
            <component
              :is="comps[getEditor(block.type)]"
              :data="block.data"
              @save="(event) => saveBlock(block.id, event)"
              @close="closeEditor(block.id)"
              :dataCySlug="'block-edit-' + ix"
              :authed="authed"
              @authRequired="emit('authRequired', true)"
              @fileProvided="
                (providedFile) => emit('fileProvided', providedFile)
              "
              @delete="deleteBlock(block.id)"
              @notification="
                (notification) => emit('notification', notification)
              "
              :flowId="flowId"
            ></component>
          </div>
        </div>
      </div>
    </div>
    <div class="row col-12 q-pa-sm">


      <NewBlockButton @addBlock="(event) => addBlock(event)"></NewBlockButton>

      <span v-if="editorBlocks.length < 1" class="text-h6"
        ><q-icon name="mdi-arrow-left" size="sm" class="q-pl-lg"></q-icon
      > Add content </span>

    </div>
  </div>
</template>

<script setup>
import { ref, watch, toRefs } from "vue";

import { nanoid } from "nanoid";

// Buttons
import NewBlockButton from "./buttons/NewBlockButton.vue";

// Editors
import HtmlEditor from "./editors/RichtextEditor.vue";
import ImageEditor from "./editors/ImageEditor.vue";
import SeparatorEditor from "./editors/SeparatorEditor.vue";
import JsonEditor from "./editors/JsonEditor.vue";

// Renderers
import HtmlBlock from "./renders/HtmlBlock.vue";
import ImageBlock from "./renders/ImageBlock.vue";
import SeparatorBlock from "./renders/SeparatorBlock.vue";
import TimelineBlock from "./renders/TimelineBlock.vue";
import JsonBlock from "./renders/JsonBlock.vue";

const comps = {
  HtmlBlock,
  HtmlEditor,
  ImageEditor,
  ImageBlock,
  SeparatorEditor,
  SeparatorBlock,
  JsonEditor,
  JsonBlock,
  TimelineBlock,
};

const emit = defineEmits([
  "change",
  "authRequired",
  "fileProvided",
  "notification",
]);

const props = defineProps({
  blocks: {
    type: Array,
  },
  flush: {
    type: Boolean,
    default: false,
  },
  authed: {
    type: Boolean,
    default: false,
  },
  flowId: {
    type: String,
    default: null,
  },
});

const editorBlocks = ref([]);
if (props.blocks) {
  editorBlocks.value = [...props.blocks];
}

const addBlock = (blockDef) => {
  const newId = nanoid();
  editorBlocks.value.push({ id: newId, type: blockDef.type, data: null });
  inEdit.value.push(newId);
};

const moveUp = (ix) => {
  // Save data for element we are moving
  const el = editorBlocks.value[ix];
  // Overwrite our element with the previosu element data
  editorBlocks.value[ix] = editorBlocks.value[ix - 1];
  // Set the previous index to our element data
  editorBlocks.value[ix - 1] = el;
  emit("change", editorBlocks.value);
};

const moveDown = (ix) => {
  // Save data for element we are moving
  const el = editorBlocks.value[ix];
  // Overwrite our element with the previosu element data
  editorBlocks.value[ix] = editorBlocks.value[ix + 1];
  // Set the previous index to our element data
  editorBlocks.value[ix + 1] = el;
  emit("change", editorBlocks.value);
};

const deleteBlock = async (blockId) => {
  const newBlocks = editorBlocks.value.filter((block) => block.id !== blockId);
  editorBlocks.value = newBlocks;
  emit("change", newBlocks);
};

// Map a block type to a renderer
const renderers = {
  richText: "HtmlBlock",
  HtmlBlock: "HtmlBlock",
  image: "ImageBlock",
  basicSeparator: "SeparatorBlock",
  timeline: "TimelineBlock",
  rawJson: "JsonBlock",
};

// Map a block type to an editor
const editors = {
  richText: "HtmlEditor",
  image: "ImageEditor",
  basicSeparator: "SeparatorEditor",
  timeline: "JsonEditor",
  rawJson: "JsonEditor",
};

// An array of blocks in edit mode
const inEdit = ref([]);

const isInEdit = (blockId) => {
  return inEdit.value.includes(blockId) ? true : false;
};

const getEditor = (blockType) => {
  return editors.hasOwnProperty(blockType) ? editors[blockType] : "json-editor";
};

const getRenderer = (blockType) => {
  return renderers.hasOwnProperty(blockType)
    ? renderers[blockType]
    : "json-block";
};

const openEditor = (blockId) => {
  // Add to inEdit index if it isn't already there
  if (inEdit.value.indexOf(blockId) === -1) {
    inEdit.value.push(blockId);
  }
};
const closeEditor = (blockId) => {
  const ix = inEdit.value.indexOf(blockId);
  inEdit.value.splice(ix, 1);
};

const saveBlock = async (blockId, data) => {
  // Get the
  const blockIx = editorBlocks.value.findIndex((x) => x.id === blockId);

  // Set the data of the blockIX item to the string after sanitizing
  editorBlocks.value[blockIx].data = data.newData;

  emit("change", editorBlocks);
};

const propBlocks = toRefs(props).blocks;

watch(propBlocks, (newValue) => {
  if (newValue.length < 1) {
    editorBlocks.value = [];
  }
});
</script>

<style lang="scss">
.block-container {
  border: dotted 1px;
  border-color: lightgray;
  border-radius: 5px;
  margin-bottom: 0.5em;
}
</style>