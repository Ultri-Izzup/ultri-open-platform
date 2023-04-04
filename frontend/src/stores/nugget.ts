import { defineStore } from 'pinia';
import { useStorage } from '@vueuse/core';

import { useAuthStore } from './auth';

const auth = useAuthStore();

export const useNuggetStore = defineStore('account', {
  state: () => ({
    nuggets: useStorage('nuggets', new Map()),
  }),
  getters: {
    get(state) {
      if(state.selectedNugget) {
        return state.selectedNugget
      }
      return 'personal';
    }
  },
  actions: {
    reset() {
      this.selectedNugget = null,
      this.accountPerms = null,
      this.accounts = {}
    },
    async fetchNuggets(nuggetType) {



      this.accounts = {};
    }
  }

});
