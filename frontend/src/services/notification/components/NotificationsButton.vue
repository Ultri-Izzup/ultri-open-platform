<template>
  <q-btn
    flat
    dense
    icon="mdi-bell"
    @click="auth.setSignInRequiredMsg(t('auth.passwordless.dialog.notification-requires-auth'))"
    v-if="!auth.isSignedIn"
  ></q-btn>
  <q-btn
    flat
    dense
    icon="mdi-bell"
    v-if="auth.isSignedIn"
  ></q-btn>
</template>

<script setup language="ts">

import { useI18n } from "vue-i18n";

import { useAuthStore } from '../../../stores/auth';
const auth = useAuthStore();

const triggerSignInDialog = async () => {
  auth.setTargetUrl('/');
  auth.setSignInRequired(true);
}

const { t } = useI18n();

</script>
