<template>
  <q-dialog ref="dialogRef">
    <q-card class="q-dialog-plugin">
      <!-- buttons example -->
      <q-card-section>
        <q-input :label="label" v-model="editUrl"></q-input
      ></q-card-section>
      <q-card-actions align="center">
        <q-btn
          icon="mdi-content-save"
          @click="onOKClick()"
          label="Save"
        ></q-btn>
      </q-card-actions>
    </q-card>
  </q-dialog>
</template>

<script setup>
import { ref, unref } from "vue";
import { useDialogPluginComponent } from "quasar";

const props = defineProps({
  label: { type: String, required: false, default: "URL" },
  url: { type: String, required: false, default: "" },
});

defineEmits([
  // REQUIRED; need to specify some events that your
  // component will emit through useDialogPluginComponent()
  //...useDialogPluginComponent.emits,
  "ok",
]);

const editUrl = ref(unref(props.url.value));

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
  onDialogOK(editUrl);
  // or with payload: onDialogOK({ ... })
  // ...and it will also hide the dialog automatically
}
</script>

<style scoped lang="scss"></style>
