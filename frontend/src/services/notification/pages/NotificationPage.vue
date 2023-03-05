<template>
<div>
  Settings Dashboard

 ID:  {{ auth.memberId }}
 EMAIL:  {{ auth.memberEmail }}
</div>

</template>

<script setup language="ts">

import { useAuthStore } from '../../../stores/auth';
const auth = useAuthStore();

</script>
