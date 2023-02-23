import { ref } from 'vue';

import Session from 'supertokens-web-js/recipe/session';

export default function useAuth() {
  // The authenticated user
  const user = ref(null);

  const emit = defineEmits(['signedOut']);

  const signOut = async () => {
    await Session.signOut();
    emit('signedOut', true);
  };

  return {
    user,
    signOut,
  };
}
