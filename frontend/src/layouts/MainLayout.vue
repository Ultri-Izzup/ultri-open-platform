<template>
  <q-layout view="hHh lpR fFf">
    <q-header elevated class="bg-primary text-white">
      <q-toolbar>
        <q-toolbar-title>
          <!--<q-avatar>
            <img src="https://cdn.quasar.dev/logo-v2/svg/logo-mono-white.svg">
          </q-avatar>-->
          Izzup
        </q-toolbar-title>
        <div>
          <!-- DISPLAY EMAIL IF LOGGED IN -->
          <span v-if="auth.isSignedIn">{{ auth.memberEmail }}</span>

          <!-- DISPLAY SIGN BUTTON  -->
          <sign-in-button v-if="!auth.isSignedIn"></sign-in-button>

          <!-- APP BUTTON-->
          <span>
            <AppsButton></AppsButton>
            <q-tooltip>{{ $t('apps.hint') }}</q-tooltip>
          </span>

          <!-- NOTIFICATIONS BUTTON -->
          <span>
            <NotificationsButton></NotificationsButton>
            <q-tooltip>{{ $t('notifications.hint') }}</q-tooltip>
          </span>

          <!-- MEMBER BUTTON -->
          <span>
            <MemberButton></MemberButton>
            <q-tooltip>{{ $t('member.hint') }}</q-tooltip>
          </span>
        </div>
      </q-toolbar>
    </q-header>

    <q-page-container>
      <PasswordlessAuthDialog
        v-model="auth.authFailed"
      ></PasswordlessAuthDialog>
      <router-view />
    </q-page-container>
  </q-layout>
</template>

<script setup>
import { useQuasar } from 'quasar';

import { useAuthStore } from '../stores/auth';

import AppsButton from '../services/member/components/AppsButton.vue';
import ChatButton from '../services/chat/components/ChatButton.vue';
import NotificationsButton from '../services/notification/components/NotificationsButton.vue';
import MemberButton from '../services/member/components/MemberButton.vue';

import PasswordlessAuthDialog from '../services/auth/components/PasswordlessDialog.vue';

import { useRouter } from 'vue-router';
const router = useRouter();

const $q = useQuasar();

const auth = useAuthStore();
</script>
