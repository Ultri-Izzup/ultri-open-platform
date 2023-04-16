<template>
  <q-page class="row justify-evenly">
    <div class="editor-container fit">
      <NuggetEditor :nuggetId="draftId"></NuggetEditor>
    </div>
    <!--  -->
  </q-page>
</template>

<script setup lang="ts">
import { useI18n } from 'vue-i18n';

import { useNuggetStore } from '../../../stores/nugget';

const nuggetStore = useNuggetStore();
const draftId = nuggetStore.addDraft('article');
console.log(draftId)


import NuggetEditor from '../../nugget/components/NuggetEditor.vue';

</script>


