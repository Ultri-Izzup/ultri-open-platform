<template><router-view /></template>

<script setup lang="ts">
import SuperTokens from 'supertokens-web-js';
import Session from 'supertokens-web-js/recipe/session';
import Passwordless from 'supertokens-web-js/recipe/passwordless';

import { useRouter } from 'vue-router';
import { useAuthStore } from './stores/auth';

const router = useRouter();
const auth = useAuthStore();


router.beforeEach(async (to, from) => {
  if (to.meta.requiresAuth) {
    if (auth.memberId && auth.memberId.length > 0) {
      // user is logged in
      console.log('ACCESS GRANTED', auth.isSignedIn, auth.memberId);
      //return true;
    } else {
      // user has not logged in yet
      console.log('NO AUTH SESSION', to.path);

      auth.setTargetUrl(to.path);
      auth.setAuthFailed(true);

      // showPasswordlessDialog()
      return from.path;
    }
  }
});


SuperTokens.init({
  appInfo: {
    apiDomain: 'http://localhost:3001',
    // apiDomain: 'https://auth.local.ultri.com',
    apiBasePath: '/auth',
    appName: 'Izzup',
  },
  recipeList: [Session.init(), Passwordless.init()],
});
</script>
