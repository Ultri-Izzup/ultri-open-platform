import { defineStore } from 'pinia';
import { useStorage } from '@vueuse/core';

import { useAuthStore } from './auth';

const auth = useAuthStore();

export const useAccountStore = defineStore('account', {
  state: () => ({
    selectedAccount: useStorage('selectedAccount', null),
    accountPerms: useStorage('accountPerms', null),
    accounts: useStorage('accounts', {}),
    lastSynced: useStorage('lastSynced', null),
  }),
  getters: {
   currentAccount(state) {
      if(state.selectedAccount) {
        return state.selectedAccount
      }
      return 'personal';
    },
    currentAccountName(state) {
      if(state.selectedAccount) {
        return state.accounts[state.currentAccount].name;
      } else {
          return auth.memberEmail;
      }
    },
    isSynced(state) {
      return state.lastSynced ? false : true;
    }

  },
  actions: {
    reset() {
      this.selectedAccount = null,
      this.accountPerms = null,
      this.accounts = {}
    },
    async refreshMemberAccounts() {



      this.accounts = {};
    }
  }

});
