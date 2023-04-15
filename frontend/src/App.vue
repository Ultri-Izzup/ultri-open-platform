<template><router-view /><v-tour name="editor" :steps="editorSteps"></v-tour></template>

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
    if (auth.memberUid && auth.memberUid.length > 0) {
      // user is logged in
      console.log('ACCESS GRANTED', auth.isSignedIn, auth.memberUid);
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

const editorSteps =  [
  {
    target: '#v-step-0',  // We're using document.querySelector() under the hood
    header: {
      title: 'Get Started',
    },
    content: `Discover <strong>Vue Tour</strong>!`
  },
  {
    target: '#v-step-1',
    content: 'An awesome plugin made with Vue.js!'
  },
  {
    target: '#v-step-2',
    content: 'Try it, you\'ll love it!<br>You can put HTML in the steps and completely customize the DOM to suit your needs.',
    params: {
      placement: 'top' // Any valid Popper.js placement. See https://popper.js.org/popper-documentation.html#Popper.placements
    }
  }
]


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
