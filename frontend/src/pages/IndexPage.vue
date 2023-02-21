<template>
  <q-page class="row items-center justify-evenly">
    <div class="">
      <q-btn label="Enter" @click="showPasswordlessDialog()"></q-btn>
    </div>
  </q-page>
</template>

<script setup lang="ts">
import { createCode } from 'supertokens-web-js/recipe/passwordless';
import PasswordlessAuthDialog from '../auth/components/PasswordlessDialog.vue';
import { useQuasar } from 'quasar';

const $q = useQuasar();

const showPasswordlessDialog = async () => {
  $q.dialog({
    component: PasswordlessAuthDialog,

    // props forwarded to your custom component
    componentProps: {},
  })
    .onOk((val) => {
      sendMagicLink(val.email);
    })
};

async function sendMagicLink(email: string) {
  try {
    console.log(email);
    let response = await createCode({
      email,
    });
    /**
     * For phone number, use this:

        let response = await createCode({
            phoneNumber: "+1234567890"
        });

    */

    // Magic link sent successfully.
    window.alert('Please check your email for the magic link');
  } catch (err: any) {
    if (err.isSuperTokensGeneralError === true) {
      // this may be a custom error message sent from the API by you,
      // or if the input email / phone number is not valid.
      window.alert(err.message);
    } else {
      window.alert('Oops! Something went wrong.');
    }
  }
}
</script>
