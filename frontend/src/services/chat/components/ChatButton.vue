<template>
  <q-btn
    flat
    dense
    icon="mdi-message"
    @click="triggerSignInDialog"
    v-if="!auth.isSignedIn"
  ></q-btn>
  <q-btn-dropdown flat dense no-caps dropdown-icon="mdi-message"  v-if="auth.isSignedIn">
    <q-list>
      <q-item icon="mdi-web" :label="$t('nav.language')" clickable>
        <q-item-section avatar>
          <q-icon name="mdi-web" />
        </q-item-section>
        <q-item-section>
          <q-select
            v-model="locale"
            :options="locales"
            :label="$t('nav.language')"
            dense
            borderless
            emit-value
            map-options
            options-dense
            style="min-width: 150px"
          />
        </q-item-section>
      </q-item>

      <q-item clickable v-close-popup @click="theme.toggleDarkMode()">
        <q-item-section avatar>
          <q-icon name="mdi-theme-light-dark" />
        </q-item-section>
        <q-item-section>
          <q-item-label>{{ $t('nav.darkMode') }}</q-item-label>
        </q-item-section>
      </q-item>

      <q-item clickable v-close-popup to="/member">
        <q-item-section avatar>
          <q-icon name="mdi-view-dashboard" />
        </q-item-section>
        <q-item-section>
          <q-item-label>{{ $t('nav.dashboard') }}</q-item-label>
        </q-item-section>
      </q-item>

      <q-item clickable v-close-popup to="/member/settings">
        <q-item-section avatar>
          <q-icon name="mdi-cog" />
        </q-item-section>
        <q-item-section>
          <q-item-label>{{ $t('nav.settings') }}</q-item-label>
        </q-item-section>
      </q-item>

      <q-item clickable v-close-popup v-if="!auth.isSignedIn" @click="triggerSignInDialog()">
        <q-item-section avatar>
          <q-icon name="mdi-login" />
        </q-item-section>
        <q-item-section>
          <q-item-label>{{ $t('nav.signIn') }}</q-item-label>
        </q-item-section>
      </q-item>

      <q-item clickable v-close-popup v-if="auth.isSignedIn" @click=" auth.signOut('/');">
        <q-item-section avatar>
          <q-icon name="mdi-logout" />
        </q-item-section>
        <q-item-section>
          <q-item-label>{{ $t('nav.signOut') }}</q-item-label>
        </q-item-section>
      </q-item>
    </q-list>
  </q-btn-dropdown>
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
