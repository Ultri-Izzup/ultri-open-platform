import { defineStore } from 'pinia';
import { useStorage } from '@vueuse/core';

import { useAuthStore } from './auth';

import { nanoid } from "nanoid";

const auth = useAuthStore();

const uuidRegex = /^[0-9a-fA-F]{8}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{12}$/gi;

export const useNuggetStore = defineStore('nugget', {
  state: () => ({
    // Map of nuggets by Uid
    nuggets: useStorage('nuggets', new Map()),
    // Local only drafts
    localDrafts: new Map(),
  }),
  getters: {
    get(state) {
      return state
    }
  },
  actions: {
    reset() {
      this.nuggets = new Map();
      this.localDrafts = new Map();
    },

    addDraft(nuggetType) {
      const draftId = nanoid();
      this.localDrafts.set(draftId, { nuggetType: nuggetType, blocks: [] });
      return draftId;
    },

    getNuggetById(nuggetId) {

      if (uuidRegex.test(nuggetId)) {
        return this.nuggets.get(nuggetId)
      } else {
        return this.localDrafts.get(nuggetId)
      }

    },

    async saveNugget(nuggetId) {

      // Require authentication
      if(!auth.isSignedIn) {
        auth.setSignInRequired(true)
      } else {
        if (uuidRegex.test(nuggetId)) {
          // Save existing nugget
        } else {
          // Create new backend nugget from draft
        }

      }


    },

    /*
    async fetchNuggetsByType(nuggetType, accountUid=null) {

    },
    async fetchNugget(nuggetUid) {

    },
    async createNugget(nuggetData, accountUid=null) {

    },
    async updateNugget(nuggetUid, nuggetData) {

    },
    async mergeNuggetBlock(nuggetUid, blocksData) {

    },
    async deleteNugget(nuggetUid) {

    },
    async deleteNuggetBlocks(nuggetUid, blockUids) {

    },
    async publishNugget(nuggetUid, pubAt=null, unPubAt=null) {

    },
    async unPublishNugget(nuggetUid) {

    }
    */
  }

});
