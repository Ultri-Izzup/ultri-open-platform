<template>
  <q-page class="row items-center justify-evenly">
    <div class="">
      {{  t('articles.list-headline') }}
    </div>
  </q-page>
</template>

<script setup lang="ts">

import { useI18n } from "vue-i18n";

import { api } from 'boot/axios'

import { inject, onMounted } from "vue";

import { useAuthStore } from '../../../stores/auth';
const auth = useAuthStore();



console.log(auth.member)

onMounted(async () => {
  await api
    .get('/member/nuggets')
    .then(response => {
      console.log(response)
    })
})



const { t } = useI18n();


</script>
