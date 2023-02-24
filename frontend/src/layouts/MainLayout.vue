<template>
  <q-layout view="hHh lpR fFf">
    <q-header elevated class="bg-primary text-white">
      <q-toolbar>
        <q-toolbar-title class="text-center">
          <!--<q-avatar>
            <img src="https://cdn.quasar.dev/logo-v2/svg/logo-mono-white.svg">
          </q-avatar>-->
          Izzup
        </q-toolbar-title>
        <div>
          <span v-if="isSignedIn">{{ auth.email }}</span>
          <q-btn flat dense icon="mdi-login" class="gt-xs"></q-btn>
          <q-btn-dropdown
            flat
            dense
            no-caps
            dropdown-icon="mdi-web"
            class="gt-sm"
          ><div class="q-pa-sm">
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
                </div>
          </q-btn-dropdown>
          <q-btn
            flat
            dense
            icon="mdi-theme-light-dark"
            class="gt-sm"
            @click="theme.toggleDarkMode()"
          >
          </q-btn>
          <q-btn flat dense icon="mdi-account" class="gt-sm"  to="/member"></q-btn>
          <q-btn-dropdown
            flat
            dense
            dropdown-icon="mdi-dots-vertical"
            class="lt-md"
          >
            <q-list>
              <q-item
                clickable
                v-close-popup
                @click="onItemClick"
                class="lt-sm"
              >
                <q-item-section avatar>
                  <q-icon name="mdi-login" />
                </q-item-section>
                <q-item-section>
                  <q-item-label>Login</q-item-label>
                </q-item-section>
              </q-item>

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
                  <q-icon name="mdi-account" />
                </q-item-section>
                <q-item-section>
                  <q-item-label>{{ $t('nav.profile') }}</q-item-label>
                </q-item-section>
              </q-item>
            </q-list>
          </q-btn-dropdown>
        </div>
      </q-toolbar>
    </q-header>

    <q-page-container>
      <router-view />
    </q-page-container>
  </q-layout>
</template>

<script setup>
import { ref } from 'vue';
import { useQuasar } from 'quasar';
import { useI18n } from 'vue-i18n'

import { useThemeStore } from '../stores/theme';

const $q = useQuasar();

const { locale } = useI18n({ useScope: 'global' })

const locales = [
  { value: 'en-US', label: 'English' },
  { value: 'es', label: 'Español' },
];

const theme = useThemeStore();
$q.dark.set(theme.darkMode);
theme.$subscribe((mutation, state) => {
  $q.dark.set(state.darkMode);
});
</script>
