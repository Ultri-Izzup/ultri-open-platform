<template>
  <q-page class="row items-center justify-evenly">
    <div class="">
      {{  $t('posts.headline.') }}
    </div>
  </q-page>
</template>

<script setup lang="ts">

import { useAuthStore } from '../../../stores/auth';
const auth = useAuthStore();

</script>
