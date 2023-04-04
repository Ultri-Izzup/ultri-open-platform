<!-- WARNING!!
The data passed to this component must be sanitized to prevent XSS.
-->
<template>
  <div class="row col-12 q-pa-md fit">
    <div v-if="data" class="row col-12">
      <q-img :src="displayUrl" :ratio="data.ratio" :fit="data.fit"
        ><div
          v-if="data.captionText"
          :class="
            data.captionPosition +
            ' ' +
            data.fontSize +
            ' ' +
            data.fontStyle +
            ' ' +
            data.fontWeight
          "
          :style="'color:' + data.fontColor"
        >
          <fnt
            :face="data.font"
            :txtStr="data.captionText"
            class="q-pa-xl"
          ></fnt></div
      ></q-img>
    </div>
  </div>
</template>

<script setup>
import { ref, unref } from "vue";

import Fnt from "../Font.vue";

const props = defineProps({
  data: {
    type: [Object, null],
    default: () => {
      return {
        url: "",
        captionText: "",
        captionPosition: "",
        fontSize: "",
        fontStyle: "",
        fontWeight: "",
        fontColor: "",
      };
    },
  },
  dataCySlug: {
    type: String,
    default: "img",
  },
});

const displayUrl = ref(null);

if (props.data && props.data.url && props.data.url.startsWith("s3:")) {
  const [cruft, perm, key] = props.data.url.split(":");
  Storage.get(key, { level: perm }).then((s3Url) => {
    displayUrl.value = s3Url;
  });
} else {
  displayUrl.value =
    props.data && props.data.url ? unref(props.data.url) : null;
}
</script>

<style lang="scss">
.xx-small {
  font-size: xx-small;
  line-height: 1em;
}

.x-small {
  font-size: x-small;
  line-height: 1em;
}

.small {
  font-size: small;
  line-height: 1em;
}
.medium {
  font-size: medium;
  line-height: 1em;
}
.large {
  font-size: large;
  line-height: 1em;
}
.x-large {
  font-size: x-large;
  line-height: 1em;
}
.xx-large {
  font-size: xx-large;
  line-height: 1em;
}
.xxx-large {
  font-size: xxx-large;
  line-height: 1em;
}
.fn-big {
  font-size: 5em;
  line-height: 1em;
}

.Italic {
  font-style: italic;
}

.Normal {
  font-style: normal;
}
</style>
