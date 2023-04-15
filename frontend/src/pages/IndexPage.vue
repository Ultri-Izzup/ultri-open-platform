<template>
  <q-page>
    <div class="text-h1 text-center">{{ $t('homepage.heading') }}</div>
    <div class="text-h2 text-center">{{ $t('homepage.tagline') }}</div>
    <div class="text-h2 text-center">
      <q-btn
        size="xl"
        label="Start Sharing"
        color="primary"
        :to="{ name: 'new-article'}"
      ></q-btn>
    </div>
  </q-page>
</template>

<script setup lang="ts">

</script>
