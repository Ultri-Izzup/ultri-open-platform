<template>
  <q-btn label="Sign Out" @click="signOut"></q-btn>
</template>

<script setup language="ts">

import useAuth from '../useAuth';

const emit = defineEmits(['signedOut']);

const { signOut } = useAuth();

async function signOut() {
  await signOut();
  emit('signedOut', true);
}
</script>
