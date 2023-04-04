<template>
  <q-dialog ref="dialogRef">
    <q-card class="q-dialog-plugin">
      <q-card-section>
        <p>Are you sure you want to delete? This cannot be undone.</p>
        <p>Please click to confirm.</p>
        <q-checkbox label="Confirm deletion" v-model="confirmed"></q-checkbox>
      </q-card-section>
      <!-- buttons example -->
      <q-card-actions align="right">
        <q-btn icon="mdi-cancel" @click="onDialogCancel" label="Cancel"></q-btn>
        <q-btn
          icon="mdi-delete"
          @click="onOKClick"
          :disable="!confirmed"
          label="Delete"
        ></q-btn>
      </q-card-actions>
    </q-card>
  </q-dialog>
</template>

<script setup>
import { ref, unref } from "vue";
import { useDialogPluginComponent } from "quasar";

defineEmits([
  // REQUIRED; need to specify some events that your
  // component will emit through useDialogPluginComponent()
  //...useDialogPluginComponent.emits,
  "ok",
]);

const { dialogRef, onDialogHide, onDialogOK, onDialogCancel } =
  useDialogPluginComponent();
// dialogRef      - Vue ref to be applied to QDialog
// onDialogHide   - Function to be used as handler for @hide on QDialog
// onDialogOK     - Function to call to settle dialog with "ok" outcome
//                    example: onDialogOK() - no payload
//                    example: onDialogOK({ /*...*/ }) - with payload
// onDialogCancel - Function to call to settle dialog with "cancel" outcome

function onOKClick() {
  // on OK, it is REQUIRED to
  // call onDialogOK (with optional payload)
  onDialogOK({ delete: "confirmed" });
  // or with payload: onDialogOK({ ... })
  // ...and it will also hide the dialog automatically
}

const confirmed = ref(false);
</script>

<style scoped lang="scss"></style>
