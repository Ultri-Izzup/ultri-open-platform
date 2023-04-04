<template>
  <q-dialog ref="dialogRef">
    <q-card class="q-dialog-plugin">
      <q-card-section>
        <q-input
          v-model="editPrimary"
          :rules="['anyColor']"
          :label="$t('Primary Color')"
        >
          <template v-slot:append>
            <q-icon name="mdi-palette" class="cursor-pointer">
              <q-popup-proxy
                cover
                transition-show="scale"
                transition-hide="scale"
              >
                <q-color v-model="editPrimary" default-view="palette"></q-color>
              </q-popup-proxy>
            </q-icon>
          </template>
        </q-input>
      </q-card-section>
      <!-- buttons example -->
      <q-card-actions align="right">
        <q-btn
          icon="mdi-cancel"
          class="bg-primary on-primary"
          @click="onDialogCancel"
          label="Cancel"
        ></q-btn>
        <q-btn
          icon="mdi-content-save-edit"
          class="bg-primary on-primary"
          @click="onOKClick"
          label="Save"
        ></q-btn>
      </q-card-actions>
    </q-card>
  </q-dialog>
</template>

<script setup>
import { ref, unref } from "vue";
import { useDialogPluginComponent } from "quasar";

import useColors from "../../../composables/useColors.js";
const { primary, secondary, onPrimary } = useColors();

const editPrimary = ref(unref(primary));

const props = defineProps({
  // ...your custom props
});

defineEmits([
  // REQUIRED; need to specify some events that your
  // component will emit through useDialogPluginComponent()
  //...useDialogPluginComponent.emits,
  "primaryChanged",
  "secondaryChanged",
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
  onDialogOK({ color: editPrimary.value });
  //primary.value = editPrimary.value;
  // or with payload: onDialogOK({ ... })
  // ...and it will also hide the dialog automatically
}
</script>

<style scoped lang="scss">
.on-primary {
  color: v-bind("onPrimary");
}
.body--light {
  --q-primary: v-bind("primary");
  //--q-secondary: #...;
  // --q-accent: #...;
}

.body--dark {
  --q-primary: v-bind("primary");
  //--q-secondary: #...;
  // --q-accent: #...;
}
</style>
