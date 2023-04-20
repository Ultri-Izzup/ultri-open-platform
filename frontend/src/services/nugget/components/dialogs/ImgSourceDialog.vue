<template>
  <q-dialog ref="dialogRef">
    <q-card class="q-dialog-plugin">
      <q-card-section class="text-h6"> Select an image source </q-card-section>
      <!-- buttons example -->
      <q-card-actions align="center">
        <q-btn
          icon="mdi-upload"
          @click="onOKClick('upload')"
          label="Upload"
        ></q-btn>
        <q-btn
          icon="mdi-camera"
          @click="onOKClick('camera')"
          label="Camera"
        ></q-btn>
        <q-btn
          icon="mdi-web"
          @click="onOKClick('url')"
          label="Image URL"
        ></q-btn>
      </q-card-actions>
    </q-card>
  </q-dialog>
</template>

<script setup>
import { ref, unref } from "vue";
import { useDialogPluginComponent } from "quasar";

const props = defineProps({
  nuggetId: { type: String, required: false, default: null },
});

defineEmits([
  // REQUIRED; need to specify some events that your
  // component will emit through useDialogPluginComponent()
  ...useDialogPluginComponent.emits,
]);

const { dialogRef, onDialogHide, onDialogOK, onDialogCancel } =
  useDialogPluginComponent();
// dialogRef      - Vue ref to be applied to QDialog
// onDialogHide   - Function to be used as handler for @hide on QDialog
// onDialogOK     - Function to call to settle dialog with "ok" outcome
//                    example: onDialogOK() - no payload
//                    example: onDialogOK({ /*...*/ }) - with payload
// onDialogCancel - Function to call to settle dialog with "cancel" outcome

const sourceRequiresSave = ["upload", "camera"];

const onOKClick = (source) => {
  // on OK, it is REQUIRED to
  if (sourceRequiresSave.includes(source) && !props.nuggetId) {
    onDialogOK({ error: "Saving is required before uploading." });
  } else {
    onDialogOK({ source: source });
  }
  // call onDialogOK (with optional payload)

  // or with payload: onDialogOK({ ... })
  // ...and it will also hide the dialog automatically
};
</script>

<style scoped lang="scss"></style>
