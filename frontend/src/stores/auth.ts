import { defineStore } from 'pinia';
import { useStorage } from '@vueuse/core';

// SuperTokens/Ultri Auth support
import Session from 'supertokens-web-js/recipe/session';
import {
  createCode,
  consumeCode,
} from 'supertokens-web-js/recipe/passwordless';
import auth from 'src/i18n/en-US/auth';

export const useAuthStore = defineStore('auth', {
  state: () => ({
    targetUrl: useStorage('targetUrl', null ),
    memberEmail: useStorage('memberEmail', null),
    memberId: useStorage('memberId', null),
    authFailed: useStorage('authFailed', false),
  }),
  getters: {
    isSignedIn(state) {
      if(state.memberId &&  state.memberId.length > 0) {
        return true;
      }
      return false;
    },
    member(state) {
      return { id: state.memberId, email: state.memberEmail };
    },
  },
  actions: {
    reset() {
      this.targetUrl = null;
      this.memberEmail = null;
      this.memberId = null;
    },
    setTargetUrl(url) {
      this.targetUrl = url;
    },
    setAuthFailed(bool, ) {
      this.authFailed = bool;
    },
    setMember(id, email) {
      this.memberId = id;
      this.memberEmail = email;
    },
    async sendEmailLogin(email) {
      try {
        console.log('SENDING Login Email: ', email);
        let response = await createCode({
          email,
        });
        console.log('RESPONSE', response);
      } catch (err) {
        console.log('ERROR', err);
        if (err.isSuperTokensGeneralError === true) {
          // this may be a custom error message sent from the API by you,
          // or if the input email / phone number is not valid.
          window.alert(err.message);
        } else {
          window.alert('Oops! Something went wrong.');
        }
      }
    },
    async sendPhoneLogin(phone) {
      try {
        console.log('PHONE', phone);
        let response = await createCode({
          phoneNumber: phone,
        });
      } catch (err) {
        console.log('ERROR', err);
        if (err.isSuperTokensGeneralError === true) {
          // this may be a custom error message sent from the API by you,
          // or if the input email / phone number is not valid.
          window.alert(err.message);
        } else {
          window.alert('Oops! Something went wrong.');
        }
      }
    },
    async handleOTP(otp) {
      try {
        let response = await consumeCode({
          userInputCode: otp,
        });

        if (response.status === 'OK') {
          console.log(response.user);
          this.setMember(response.user.id, response.user.email);

          if (response.createdNewUser) {
            // user sign up success
          } else {
            // user sign in success
          }

          if(this.targetUrl && this.targetUrl.length > 0) {
            this.router.push(this.targetUrl);
          }

          return { status: 'OK' };

        } else if (response.status === 'INCORRECT_USER_INPUT_CODE_ERROR') {
          return {
            status: 'INCORRECT_USER_INPUT_CODE_ERROR',
            maximumCodeInputAttempts: response.maximumCodeInputAttempts,
            failedCodeInputAttemptCount: response.failedCodeInputAttemptCount
          }
        } else if (response.status === 'EXPIRED_USER_INPUT_CODE_ERROR') {
          // it can come here if the entered OTP was correct, but has expired because
          // it was generated too long ago.
          return {
            status: 'EXPIRED_USER_INPUT_CODE_ERROR'
          }
        } else {
          // this can happen if the user tried an incorrect OTP too many times.
          return {
            status: 'LOGIN_FAILED_ERROR'
          }
        }
      } catch (err) {
        console.log('ERROR', err);
        if (err.isSuperTokensGeneralError === true) {
          // this may be a custom error message sent from the API by you.
          return {
            status: err.message
          }
        } else {
          return {
            status: 'LOGIN_FAILED'
          }
        }
      }
    },
    async signOut() {
      console.log('SIGNOUT');
      await Session.signOut();
      this.reset();
    },
    validateEmail(email) {
      return /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,4})+$/.test(email);
    },
    validateCode(otp) {
      return /^[0-9]{6}$/.test(otp);
    },
  },
});
