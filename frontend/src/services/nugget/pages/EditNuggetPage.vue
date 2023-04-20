<template>
  <q-page class="row justify-evenly">
    <div class="editor-container fit">
      <NuggetEditor :nuggetUid="nuggetUid"></NuggetEditor>
    </div>
    <!--  -->
  </q-page>
</template>

<script setup lang="ts">

import NuggetEditor from '../../nugget/components/NuggetEditor.vue';

import { useRoute } from 'vue-router';

const route = useRoute();

const nuggetUid = route.params.nuggetUid;


</script>
