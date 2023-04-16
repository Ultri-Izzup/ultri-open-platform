<template>
  <q-layout view="hHh lpR fFf">
    <q-header elevated class="bg-primary text-white">
      <q-toolbar>
        <q-toolbar-title>
          <!--<q-avatar>
            <img src="https://cdn.quasar.dev/logo-v2/svg/logo-mono-white.svg">
          </q-avatar>-->
          <span><router-link :to="{ name: 'home'}" class="navbar-link">Izzup</router-link></span>
        </q-toolbar-title>
        <div>
          <!-- DISPLAY EMAIL IF LOGGED IN -->
          <span class="gt-sm q-pr-md">{{ auth.memberEmail }}</span>

          <!-- DISPLAY SIGN BUTTON -->
          <span>
          <sign-in-button v-if="!auth.isSignedIn"></sign-in-button>
          <q-tooltip>{{ $t('nav.signIn') }}</q-tooltip></span>


          <!-- APP BUTTON-->
          <span v-if="auth.isSignedIn">
            <AppsButton></AppsButton>
            <q-tooltip>{{ $t('apps.hint') }}</q-tooltip>
          </span>

          <!-- NOTIFICATIONS BUTTON -->
          <span v-if="auth.isSignedIn">
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
        v-model="auth.signInRequired"
      ></PasswordlessAuthDialog>
      <WelcomeDialog
        v-model="auth.isNewMember"
      ></WelcomeDialog>
      <router-view />
    </q-page-container>
  </q-layout>
</template>

<script setup>
import { useAuthStore } from '../stores/auth';

import AppsButton from '../services/member/components/AppsButton.vue';
// import ChatButton from '../services/chat/components/ChatButton.vue';
import NotificationsButton from '../services/notification/components/NotificationsButton.vue';
import MemberButton from '../services/member/components/MemberButton.vue';
import SignInButton from '../services/auth/components/SignInButton.vue';

import PasswordlessAuthDialog from '../services/auth/components/PasswordlessDialog.vue';
import WelcomeDialog from '../services/member/components/WelcomeDialog.vue';

const auth = useAuthStore();
</script>

<style lang="scss">

</style>
