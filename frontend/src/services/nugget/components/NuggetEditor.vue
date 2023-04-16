<template>
  <div class="nugget-container full-width">
{{ nugget  }}
    <q-input v-model="nugget.publicTitle" class="fit title-field q-px-md" autogrow placeholder="Add a Title"
      hide-bottom-space></q-input>


    <BlocksEditor class="full-width" :nuggetId="nuggetId"></BlocksEditor>
    <q-page-sticky position="bottom-right" :offset="[18, 18]">
      <q-btn push fab icon="mdi-content-save" color="accent" @click="saveNugget(nuggetId)">
      </q-btn>
    </q-page-sticky>
  </div>
</template>

<script setup>

import BlocksEditor from './BlocksEditor.vue';

import { useNuggetStore } from '../../../stores/nugget';

const nuggetStore = useNuggetStore();

const props = defineProps({
  nuggetId: {
    type: String,
  },
});

const nugget = nuggetStore.getNuggetById(props.nuggetId)


const saveNugget= (nuggetId) => {
  console.log(nuggetId)
  console.log(nugget)
  // Save to API
  nuggetStore.saveNugget(nuggetId)

  // Change route to new nugget ID
  // nugget/:nuggetId
};

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
