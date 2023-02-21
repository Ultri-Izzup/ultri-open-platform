<template>
  <q-dialog ref="dialogRef">
    <q-card class="q-dialog-plugin" v-if="view == 'enterEmail'">
      <q-form @submit="onEmailSubmit" @reset="onEmailReset">
        <q-card-section>
          <div class="dialog-header">
            {{ $t('auth.passwordless.dialog.email-form-title') }}
          </div>
          <div class="dialog-body">
            {{ $t('auth.passwordless.dialog.email-form-body') }}
          </div>
        </q-card-section>
        <q-card-section>
          <q-input :label="$t('auth.passwordless.dialog.email-form-email-hint')" type="email" v-model="email"></q-input>
        </q-card-section>
        <!-- buttons example -->
        <q-card-actions align="right">
          <q-btn icon="mdi-email-fast-outline" color="primary" type="submit"
            :label="$t('auth.passwordless.dialog.email-form-button')" :disable="!sendLinkEnabled"></q-btn>
        </q-card-actions>
      </q-form>
    </q-card>
    <q-card class="q-dialog-plugin" v-if="view == 'enterCode'">
      <q-form @submit="onCodeSubmit" @reset="onCodeReset">
        <q-card-section>
          <div class="dialog-header">
            {{ $t('auth.passwordless.dialog.code-form-title') }}
          </div>
          <div class="dialog-body">
            {{ $t('auth.passwordless.dialog.code-form-body') }}
          </div>
          <q-card-section>
            <q-input :label="$t('auth.passwordless.dialog.code-form-email-hint')" v-model="otp"></q-input>
          </q-card-section>
        </q-card-section>
        <q-card-actions align="right">
          <q-btn icon="mdi-login-variant" color="primary" type="submit"
            :label="$t('auth.passwordless.dialog.code-form-button')" :disable="!signinEnabled"></q-btn>
        </q-card-actions>
      </q-form>
    </q-card>
  </q-dialog>
</template>

<script setup language="ts">
import { ref, computed, watch } from 'vue';
import { useDialogPluginComponent } from 'quasar';

import { createCode } from 'supertokens-web-js/recipe/passwordless';
import { consumeCode } from "supertokens-web-js/recipe/passwordless";

const props = defineProps({});
const email = ref(null);
const validEmail = ref(false);
const emailSubmitted = ref(false);
const sendLinkEnabled = computed(() => {
  return validEmail.value && !emailSubmitted.value ? true : false;
});

const otp = ref(null);
const validCode = ref(false);
const codeSubmitted = ref(false);
const signinEnabled = computed(() => {
  return validCode.value && !codeSubmitted.value ? true : false;
});

const view = ref('enterEmail');

defineEmits([
  // REQUIRED; need to specify some events that your
  // component will emit through useDialogPluginComponent()
  //...useDialogPluginComponent.emits,
  'ok',
]);

const validateEmail = (email) => {
  return /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,4})+$/.test(email);
};

const validateCode = (otp) => {
  return /^[0-9]{6}$/.test(otp);
};

const onEmailSubmit = () => {
  emailSubmitted.value = true;
  console.log('EMAIL: ', email.value);
  sendCode(email.value);
  view.value = 'enterCode'
};

const onEmailReset = () => {
  email.value = null;
};

const onCodeSubmit = () => {
  codeSubmitted.value = true;
  console.log('CODE: ', otp.value);
  handleOTP(otp.value);
};

const onCodeReset = () => {
  otp.value = null;
};

const { dialogRef, onDialogOK } = useDialogPluginComponent();
// dialogRef      - Vue ref to be applied to QDialog
// onDialogHide   - Function to be used as handler for @hide on QDialog
// onDialogOK     - Function to call to settle dialog with "ok" outcome
//                    example: onDialogOK() - no payload
//                    example: onDialogOK({ /*...*/ }) - with payload
// onDialogCancel - Function to call to settle dialog with "cancel" outcome

const onOKClick = () => {
  // on OK, it is REQUIRED to
  // call onDialogOK (with optional payload)
  onDialogOK({ pubAt: newPubAt.value, pubDomain: editDomain.value });
  //primary.value = editPrimary.value;
  // or with payload: onDialogOK({ ... })
  // ...and it will also hide the dialog automatically
};

async function sendCode(email) {
  try {
    let response = await createCode({
      email,
    });
    /**
     * For phone number, use this:

        let response = await createCode({
            phoneNumber: "+1234567890"
        });

    */
    console.log(response);

    // Magic link sent successfully.
    // window.alert('Please check your email for the magic link');
  } catch (err) {
    if (err.isSuperTokensGeneralError === true) {
      // this may be a custom error message sent from the API by you,
      // or if the input email / phone number is not valid.
      window.alert(err.message);
    } else {
      window.alert('Oops! Something went wrong.');
    }
  }
}

async function handleOTP(otp) {
  try {
    let response = await consumeCode({
      userInputCode: otp
    });

    console.log(response.user)

    if (response.status === "OK") {
      if (response.createdNewUser) {
        // user sign up success
      } else {
        // user sign in success
      }
      window.location.assign("/home")
    } else if (response.status === "INCORRECT_USER_INPUT_CODE_ERROR") {
      // the user entered an invalid OTP
      window.alert("Wrong OTP! Please try again. Number of attempts left: " + (response.maximumCodeInputAttempts - response.failedCodeInputAttemptCount));
    } else if (response.status === "EXPIRED_USER_INPUT_CODE_ERROR") {
      // it can come here if the entered OTP was correct, but has expired because
      // it was generated too long ago.
      window.alert("Old OTP entered. Please regenerate a new one and try again");
    } else {
      // this can happen if the user tried an incorrect OTP too many times.
      window.alert("Login failed. Please try again");
      window.location.assign("/auth")
    }
  } catch (err) {
    if (err.isSuperTokensGeneralError === true) {
      // this may be a custom error message sent from the API by you.
      window.alert(err.message);
    } else {
      window.alert("Oops! Something went wrong.");
    }
  }
}

watch(email, (newValue, oldValue) => {
  console.log(newValue, oldValue);
  if (validateEmail(newValue)) {
    validEmail.value = true;
  } else {
    validEmail.value = false;
  }
});

watch(otp, (newValue, oldValue) => {
  console.log(newValue, oldValue);
  if (validateCode(newValue)) {
    validCode.value = true;
  } else {
    validCode.value = false;
  }
});
</script>

<style scoped lang="scss"></style>
