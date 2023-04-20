import { defineStore } from 'pinia';
import { useStorage } from '@vueuse/core';

import { useAuthStore } from './auth';

import { izzupApi } from '../boot/axios'

import { nanoid } from 'nanoid';

const auth = useAuthStore();

const isUUID =
  /^[0-9a-fA-F]{8}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{12}$/gi;

export const useNuggetStore = defineStore('nugget', {
  state: () => ({
    // Map of nuggets by Uid.
    // Saved to Local Storage on change
    savedNuggets: useStorage('savedNuggets', {} ),
    // Editable Nuggets.
    // These can be addressed directly in any Vue file.
    // "Saving" the nugget will copy the current state to savedNuggets.
    // "Saving" will also persist to cloud if on network.
    openNuggets: new Map() ,
  }),
  getters: {
    get(state) {
      return state;
    },
  },
  actions: {
    reset() {
      this.savedNuggets = {};
      this.openNuggets = new Map;
    },

    addDraft(nuggetType) {
      const draftId = nanoid();
      const baseObject = { nuggetType: nuggetType, blocks: [] }
      this.openNuggets.set(draftId, baseObject);
      console.log('BASE OBJECT', baseObject)
      return draftId;
    },

    editableNuggetByUid(nuggetUid) {
      if(!this.openNuggets.has(nuggetUid) && this.savedNuggets.hasOwnProperty(nuggetUid)) {
        const nugget = this.savedNuggets[nuggetUid];
        this.openNuggets.set(nuggetUid, nugget);
      }

      return this.openNuggets.get(nuggetUid);

    },

    async saveNugget(nuggetUid) {

      // Require authentication
      if (!auth.isSignedIn) {
        auth.setSignInRequired(true);
      } else {
        if (isUUID.test(nuggetUid)) {
          // Save existing nugget
          await this.savePersistedNugget(nuggetUid);
        } else {
          // Create new backend nugget from draft
          await this.saveDraft(nuggetUid);
        }
      }
    },

    async savePersistedNugget(nuggetUid) {
      // Require authentication

      if (!auth.isSignedIn) {
        auth.setSignInRequired(true);
      } else {
        // Post to new nugget
        const nug = this.openNuggets.get(nuggetUid);
        console.log('NUG', nug)
        const apiResponse = await izzupApi.post(
          '/nugget/'+nuggetUid,
          nug
        );

        this.savedNuggets[apiResponse.data.uid] = this.openNuggets.get(nuggetUid);

      }
    },

    async saveDraft(nuggetUid) {
      // Require authentication

      console.log(this.openNuggets)
      console.log(nuggetUid)

      if (!auth.isSignedIn) {
        auth.setSignInRequired(true);
      } else {
        // Post to new nugget
        const nug = this.openNuggets.get(nuggetUid);
        console.log('NUG', nug)
        const apiResponse = await izzupApi.post(
          '/nugget',
          nug
        );

        const newNugget = {
          ...apiResponse.data,
          ...this.openNuggets.get(nuggetUid),
        };

        this.savedNuggets[apiResponse.data.uid] = newNugget;
        this.openNuggets.set(apiResponse.data.uid, newNugget);

        this.router.push({name: 'nugget-editor', params: {nuggetUid: apiResponse.data.uid}});
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
  },
});
