<template>
  <q-btn
    flat
    dense
    icon="mdi-message"
    class="gt-xs"
    @click="triggerSignInDialog"
  ></q-btn>
</template>

<script setup language="ts">

import { useAuthStore } from '../../../stores/auth';
const auth = useAuthStore();

const triggerSignInDialog = async () => {
  auth.setTargetUrl('/');
  auth.setSignInRequired(true);
  console.log(auth.targetUrl)
}

</script>
