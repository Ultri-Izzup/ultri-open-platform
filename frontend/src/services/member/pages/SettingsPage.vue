<template>
<div>
  {{ t('posts.headline')}}

 ID:  {{ auth.memberUid }}
 EMAIL:  {{ auth.memberEmail }}
</div>

</template>

<script setup language="ts">

import { useI18n } from "vue-i18n";

import { useAuthStore } from '../../../stores/auth';
const auth = useAuthStore();

const { t } = useI18n();

</script>
