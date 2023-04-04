<template>
  <!-- A button to add a new Block of a given type. -->
  <q-btn rounded icon="mdi-plus"
    ><q-menu>
      <q-list>
        <!-- Rich Text Content / HTML block -->
        <q-separator></q-separator>
        <q-item
          v-close-popup
          clickable
          @click="addBlock('richText')"
          :data-cy="dataCySlug + '-richtext'"
        >
          <q-item-section>Text</q-item-section>
        </q-item>

        <!-- Image centric blocks -->
        <q-separator></q-separator>

        <!-- Image Choices -->
        <q-item
          v-close-popup
          clickable
          @click="addBlock('image')"
          :data-cy="dataCySlug + '-images-image'"
        >
          <q-item-section>Image</q-item-section>
        </q-item>

        <!-- Page Separators -->
        <q-separator></q-separator>
        <q-item
          v-close-popup
          clickable
          @click="addBlock('basicSeparator')"
          :data-cy="dataCySlug + '-separator-basic'"
        >
          <q-item-section>Separator</q-item-section>
        </q-item>
      </q-list>
    </q-menu></q-btn
  >
</template>

<script>
import { defineComponent, ref } from "vue";
import { useQuasar } from "quasar";

export default defineComponent({
  name: "NewBlockButton",
  props: {
    btnLabel: {
      type: String,
      default: "New Block",
    },
    nextBlock: {
      type: String,
      default: "",
    },
    dataCySlug: {
      type: String,
      default: "tst",
    },
  },
  emits: ["addBlock"],
  setup(props, { emit }) {
    const addBlock = (type) => {
      const def = { type: type, nextBlock: props.nextBlock };

      //  @todo Add debounce
      emit("addBlock", def);
    };

    return {
      addBlock,
    };
  },
});
</script>
