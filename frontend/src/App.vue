<template><router-view /></template>

<script setup lang="ts">
import SuperTokens from 'supertokens-web-js';
import Session from 'supertokens-web-js/recipe/session';
import Passwordless from 'supertokens-web-js/recipe/passwordless';

SuperTokens.init({
  appInfo: {
    apiDomain: 'http://localhost:3001',
    apiBasePath: '/auth',
    appName: 'Izzup',
  },
  recipeList: [Session.init(), Passwordless.init()],
});
</script>
