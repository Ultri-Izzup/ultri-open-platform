<template>
  <q-page class="row items-center justify-evenly">
    <div class="">
      {{  t('articles.list-headline') }}
    </div>
  </q-page>
</template>

<script setup lang="ts">

import { useI18n } from "vue-i18n";

import { useAuthStore } from '../../../stores/auth';
const auth = useAuthStore();

const { t } = useI18n();


</script>
