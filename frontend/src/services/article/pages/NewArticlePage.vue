<template>
  <q-page class="row justify-evenly">
    <div class="editor-container fit">
      <NuggetEditor :nugget="{}" @save="saveNugget($event)"></NuggetEditor>
    </div>
    <!--  -->
  </q-page>
</template>

<script setup lang="ts">
import { useI18n } from 'vue-i18n';

import NuggetEditor from '../../nugget/components/NuggetEditor.vue';

import { useAuthStore } from '../../../stores/auth';
const auth = useAuthStore();

const { t } = useI18n();
</script>

<style lang="scss">
.editor-container {
  margin-bottom: 1em;
  min-width: 330px;
  max-width: 900px;
}
</style>
