import { ref } from 'vue';

export default function useAuth() {

  const authMember = ref(null);

  return {
    authMember
  }
}
