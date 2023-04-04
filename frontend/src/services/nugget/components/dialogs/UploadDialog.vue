<template>
  <q-dialog ref="dialogRef">
    <q-card class="q-dialog-plugin">
      <!-- buttons example -->
      <q-card-section>
        <q-file v-model="file" :label="label"></q-file
      ></q-card-section>
      <q-card-actions align="center">
        <q-btn icon="mdi-upload" @click="onOKClick()" label="Upload"></q-btn>
      </q-card-actions>
    </q-card>
  </q-dialog>
</template>

<script setup>
import { ref, unref } from "vue";
import { useDialogPluginComponent } from "quasar";

const props = defineProps({
  label: { type: String, required: false, default: "Image" },
});

defineEmits([
  // REQUIRED; need to specify some events that your
  // component will emit through useDialogPluginComponent()
  //...useDialogPluginComponent.emits,
  "ok",
  "notification",
]);

const file = ref(null);

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
  onDialogOK(file.value);
  // or with payload: onDialogOK({ ... })
  // ...and it will also hide the dialog automatically
}
</script>

<style scoped lang="scss"></style>
