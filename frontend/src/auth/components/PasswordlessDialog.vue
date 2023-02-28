<template>
  <q-dialog ref="dialogRef" persistent>
    <q-card class="q-dialog-plugin" v-if="view == 'enterEmail'">
      <q-form @submit="onEmailSubmit" @reset="onEmailReset">
        <q-card-section>
          <div class="dialog-header row">
            {{ $t('auth.passwordless.dialog.email-form-title') }}
            <q-space></q-space>
            <q-btn
              icon="mdi-close"
              round
              dense
              v-close-popup
              @click="auth.setTargetUrl(null)"
            ></q-btn>
          </div>
          <div class="dialog-body">
            {{ $t('auth.passwordless.dialog.email-form-body') }}
          </div>
        </q-card-section>
        <q-card-section>
          <q-input
            :label="$t('auth.passwordless.dialog.email-form-email-hint')"
            type="email"
            v-model="email"
          ></q-input>
        </q-card-section>
        <!-- buttons example -->
        <q-card-actions align="right">
          <q-btn
            icon="mdi-email-fast-outline"
            color="primary"
            type="submit"
            :label="$t('auth.passwordless.dialog.email-form-button')"
            :disable="!sendLinkEnabled"
          ></q-btn>
        </q-card-actions>
      </q-form>
    </q-card>
    <q-card class="q-dialog-plugin" v-if="view == 'enterCode'">
      <q-form @submit="onCodeSubmit" @reset="onCodeReset">
        <q-card-section>
          <div class="dialog-header row">
            {{ $t('auth.passwordless.dialog.code-form-title') }}
            <q-space></q-space>
            <q-btn
              icon="mdi-close"
              round
              dense
              v-close-popup
              @click="auth.setTargetUrl(null)"
            ></q-btn>
          </div>
          <div class="dialog-body">
            {{ $t('auth.passwordless.dialog.code-form-body') }}
          </div>
          <q-card-section>
            <q-input
              :label="$t('auth.passwordless.dialog.code-form-email-hint')"
              v-model="otp"
            ></q-input>
          </q-card-section>
        </q-card-section>
        <q-card-actions align="right">
          <q-btn
            icon="mdi-login-variant"
            color="primary"
            type="submit"
            :label="$t('auth.passwordless.dialog.code-form-button')"
            :disable="!signinEnabled"
          ></q-btn>
        </q-card-actions>
      </q-form>
    </q-card>
  </q-dialog>
</template>

<script setup language="ts">
import { ref, computed, watch } from 'vue';
import { useDialogPluginComponent } from 'quasar';

import { useAuthStore } from '../../stores/auth';
const auth = useAuthStore();

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

const reset = () => {
  email.value = null;
  validEmail.value = false;
  emailSubmitted.value = false;
  otp.value = null;
  validCode.value = false;
  codeSubmitted.value = false;
  view.value = 'enterEmail';
};

defineEmits([
  // REQUIRED; need to specify some events that your
  // component will emit through useDialogPluginComponent()
  //...useDialogPluginComponent.emits,
  'ok',
]);

const onEmailSubmit = () => {
  emailSubmitted.value = true;
  auth.sendEmailLogin(email.value);
  view.value = 'enterCode';
};

const onEmailReset = () => {
  email.value = null;
};

const onCodeSubmit = () => {
  codeSubmitted.value = true;
  auth.handleOTP(otp.value);
  reset();
  onDialogOK();
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
  onDialogOK();
  //primary.value = editPrimary.value;
  // or with payload: onDialogOK({ ... })
  // ...and it will also hide the dialog automatically
};

watch(email, (newValue, oldValue) => {
  if (auth.validateEmail(newValue)) {
    validEmail.value = true;
  } else {
    validEmail.value = false;
  }
});

watch(otp, (newValue, oldValue) => {
  if (auth.validateCode(newValue)) {
    validCode.value = true;
  } else {
    validCode.value = false;
  }
});
</script>

<style scoped lang="scss"></style>
