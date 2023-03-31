<template>
<div>
  Member Dashboard

 ID:  {{ auth.memberUid }}
 EMAIL:  {{ auth.memberEmail }}
</div>

</template>

<script setup language="ts">

import { useAuthStore } from '../../../stores/auth';
const auth = useAuthStore();

</script>
