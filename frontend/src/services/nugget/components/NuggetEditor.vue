<template>
  <div class="nugget-container full-width">
    NUGGET: {{  nugget }}
    <br />
    Saved Nuggets:
    {{
      nuggetStore.savedNuggets }}
    <br />
    Open Nuggets:
    {{ nuggetStore.openNuggets }}


    <q-input
      v-model="nugget.publicTitle"
      class="fit title-field q-px-md"
      autogrow
      placeholder="Add a Title"
      hide-bottom-space
    ></q-input>


    <!--<BlocksEditor class="full-width" :nuggetUid="nuggetUid"></BlocksEditor> -->
    <q-page-sticky position="bottom-right" :offset="[18, 18]">
      <q-btn
        push
        fab
        icon="mdi-content-save"
        color="accent"
        @click="saveNugget(nuggetUid)"
      >
      </q-btn>
    </q-page-sticky>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';

// import { storeToRefs } from 'pinia';

import BlocksEditor from './BlocksEditor.vue';

import { useNuggetStore } from '../../../stores/nugget';
const nuggetStore = useNuggetStore();

const props = defineProps({
  nuggetUid: {
    type: String,
  },
});

console.log('Nugget UID', props.nuggetUid);

const nugget = nuggetStore.editableNuggetByUid(props.nuggetUid);

console.log(nugget);

const saveNugget = (nuggetUid) => {
  console.log(nuggetUid);
  console.log(nugget);
  // Save to API
  nuggetStore.saveNugget(nuggetUid);
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
