<template>
  <q-btn-dropdown flat dense no-caps dropdown-icon="mdi-dots-grid">
    <q-list>
        <q-item clickable>
          <q-btn-dropdown flat dense no-caps :label="t('nav.publish')">
            <q-list>
                <q-item clickable v-close-popup @click="onItemClick">
                  <q-item-section avatar>
          <q-icon name="mdi-file-document" color="primary"></q-icon>
        </q-item-section>
                  <q-item-section>
                    <q-item-label>{{ t('nav.articles') }}</q-item-label>
                  </q-item-section>
                </q-item>

                <q-item clickable v-close-popup @click="onItemClick">
                  <q-item-section avatar>
          <q-icon name="mdi-post" color="primary"></q-icon>
        </q-item-section>
                  <q-item-section>
                    <q-item-label>{{ t('nav.posts') }}</q-item-label>
                  </q-item-section>
                </q-item>
              </q-list>
          </q-btn-dropdown>
        </q-item>

        <q-item clickable>
          <q-btn-dropdown flat dense no-caps :label="t('nav.sell')">
            <q-list>
                <q-item clickable v-close-popup @click="onItemClick">
                  <q-item-section avatar>
          <q-icon name="mdi-newspaper" color="primary"></q-icon>
        </q-item-section>
                  <q-item-section>
                    <q-item-label>{{ t('nav.classifieds') }}</q-item-label>
                  </q-item-section>
                </q-item>

                <q-item clickable v-close-popup @click="onItemClick">
                  <q-item-section avatar>
          <q-icon name="mdi-store" color="primary"></q-icon>
        </q-item-section>
                  <q-item-section>
                    <q-item-label>{{ t('nav.shops') }}</q-item-label>
                  </q-item-section>
                </q-item>
              </q-list>
          </q-btn-dropdown>
        </q-item>

      </q-list>
  </q-btn-dropdown>
</template>

<script setup language="ts">

import { useI18n } from "vue-i18n";

import { useAuthStore } from '../../../stores/auth';
const auth = useAuthStore();

const { t } = useI18n();

</script>
