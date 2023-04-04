<template>
  <q-dialog ref="dialogRef">
    <q-card class="q-dialog-plugin">
      <q-card-section>
        <q-checkbox label="Publish" v-model="published"></q-checkbox>
        <q-select
          outlined
          v-model="editDomain"
          :options="domains"
          emit-value
          map-options
          label="Domain"
        ></q-select>
        <!--
        <span class="cursor-pointer">
                  <date-display
                    :rawDate="pubAt"
                    displayFormat="YYYY/MM/DD hh:mm a"
                    label="Publish At"
                  ></date-display>
                  <q-icon
                    size="xs"
                    name="edit"
                    v-if="!pubAt || pubAt.length < 1"
                  ></q-icon>
                  <q-popup-edit
                    :model-value="pubAt"
                    auto-save
                    @save="
                      (v, iv) => {
                        const isoDate = v + ':00.000Z';
                        updateFlowProp(id, 'pubAt', isoDate);
                      }
                    "
                  >
                    <template v-slot="scope">
                      <q-date
                        dense
                        v-model="scope.value"
                        :model-value="scope.value"
                        mask="YYYY-MM-DDTHH:mm"
                        hint="The day the Flow is published."
                      >
                      </q-date>
                      <q-time
                        dense
                        v-model="scope.value"
                        :model-value="scope.value"
                        mask="YYYY-MM-DDTHH:mm"
                        hint="The time the Flow is published."
                      >
                      </q-time>

                      <div>
                        <q-btn
                          flat
                          dense
                          color="negative"
                          icon="cancel"
                          @click.stop="scope.cancel"
                        ></q-btn>

                        <q-btn
                          flat
                          dense
                          color="positive"
                          icon="check_circle"
                          @click.stop="scope.set"
                          :disable="scope.initialValue === scope.value"
                        ></q-btn>
                      </div>
                    </template>
                  </q-popup-edit>
                </span>
                -->
      </q-card-section>
      <!-- buttons example -->
      <q-card-actions align="right">
        <q-btn
          icon="mdi-close"
          color="primary"
          @click="onOKClick()"
          label="Close"
        ></q-btn>
      </q-card-actions>
    </q-card>
  </q-dialog>
</template>

<script setup>
import { ref, computed, watch } from "vue";
import { useDialogPluginComponent } from "quasar";

import domains from "../../../data/domains.json";

const props = defineProps({
  pubAt: { type: String, required: false, default: null },
  unPubAt: { type: String, required: false, default: null },
  pubDomain: { type: String, required: false, default: "izzup.com" },
});

defineEmits([
  // REQUIRED; need to specify some events that your
  // component will emit through useDialogPluginComponent()
  //...useDialogPluginComponent.emits,
  "ok",
]);

const published = ref(false);
if (props.pubAt) {
  published.value = true;
}

const newPubAt = ref(null);

const editDomain = ref(props.pubDomain);

const { dialogRef, onDialogHide, onDialogOK, onDialogCancel } =
  useDialogPluginComponent();
// dialogRef      - Vue ref to be applied to QDialog
// onDialogHide   - Function to be used as handler for @hide on QDialog
// onDialogOK     - Function to call to settle dialog with "ok" outcome
//                    example: onDialogOK() - no payload
//                    example: onDialogOK({ /*...*/ }) - with payload
// onDialogCancel - Function to call to settle dialog with "cancel" outcome

watch(published, (newValue) => {
  if (newValue) {
    newPubAt.value = new Date().toISOString();
  } else {
    newPubAt.value = null;
  }
});

function onOKClick() {
  // on OK, it is REQUIRED to
  // call onDialogOK (with optional payload)
  onDialogOK({ pubAt: newPubAt.value, pubDomain: editDomain.value });
  //primary.value = editPrimary.value;
  // or with payload: onDialogOK({ ... })
  // ...and it will also hide the dialog automatically
}
</script>

<style scoped lang="scss"></style>
