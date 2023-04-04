<template>
  <div class="nugget-container full-width">

      <q-input v-model="nuggetTitle" class="fit title-field q-px-md" autogrow placeholder="Add a Title" hide-bottom-space></q-input>


    <BlocksEditor class="full-width"></BlocksEditor>
    <q-page-sticky position="bottom-right" :offset="[18, 18]">
            <q-btn fab icon="mdi-content-save" color="accent"></q-btn>
          </q-page-sticky>
  </div>
</template>

<script setup>
import { ref, unref } from 'vue';
import BlocksEditor from './BlocksEditor.vue';

const emit = defineEmits(['change', 'fileProvided']);

const props = defineProps({
  nugget: {
    type: [Object],
  },
});

const blocks = ref([]);
if (props.nugget.blocks) {
  blocks.value = ref(props.nugget.blocks);
}
console.log(props);
const saveBlocks = (event) => {
  const newNugget = [{ id: props.nugget.id, blocks: unref(event) }];
  emit('change', newNugget);
};

const nuggetTitle = ref(null);

const title = ref(null);
</script>

<style lang="scss">
.nugget-container {

  padding: 1px;
  margin: 0.5em 0.5em 1em 0.5em;
  position: relative;
  min-width: 330px;
}
.q-textarea .q-field__native {
  font-size: 2.5em;
  line-height: 1.5em;
}
</style>
