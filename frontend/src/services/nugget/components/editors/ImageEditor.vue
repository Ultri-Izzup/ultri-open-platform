<template>
  <!-- Component div -->
  <div class="row col-12 q-pa-md">
    <!-- Display image with live updates -->
    {{ editorData.imageSource }}
    <div id="'img-' + editorData.id" class="row col-12">
      <q-img
        :src="editorData.imageSource == 'url' ? editorData.url : displayUrl"
        :ratio="editorData.ratio"
        :fit="editorData.fit"
        ><div
          v-if="editorData.captionText"
          :class="
            editorData.captionPosition +
            ' ' +
            editorData.fontSize +
            ' ' +
            editorData.fontStyle +
            ' ' +
            editorData.fontWeight
          "
          :style="'color:' + editorData.fontColor"
        >
          <fnt :face="editorData.font" :txtStr="editorData.captionText">{{
            editorData.captionText
          }}</fnt>
        </div></q-img
      >
    </div>

    <!-- Image handling -->
    <div class="row col-12 q-pa-xs" v-if="editorData.imageSource == 'url'">
      <q-input
        outlined
        v-model="editorData.url"
        label="Image URL"
        class="col-12"
        :data-cy="dataCySlug + '-url-fld'"
      ></q-input>
    </div>
    <!--
    <div class="row col-12 q-pa-xs" v-if="imgSource == 'upload'">
      <q-input
        outlined
        v-model="editorData.url"
        label="S3 Key"
        class="col-12"
        :data-cy="dataCySlug + '-url-fld'"
      ></q-input>
    </div>
  -->

    <div class="row col-12 q-pa-xs">
      <div class="col-7 q-pt-md text-body1">Aspect Ratio:</div>
      <div class="col-5">
        <q-select
          filled
          v-model="editorData.ratio"
          :options="ratioOptions"
          emit-value
          map-options
          dense
          options-dense
          :data-cy="dataCySlug + '-ratio-select'"
        ></q-select>
      </div>
    </div>

    <div class="row col-12 q-pa-xs">
      <div class="col-7 q-pt-md text-body1">Fit:</div>
      <div class="col-5">
        <q-select
          filled
          v-model="editorData.fit"
          :options="fitOptions"
          emit-value
          map-options
          dense
          options-dense
          :data-cy="dataCySlug + '-fit-select'"
        ></q-select>
      </div>
    </div>

    <!-- Alt Text-->
    <div class="row col-12 q-pa-xs">
      <q-input
        outlined
        v-model="editorData.altText"
        label="Alt Text"
        class="col-12"
        :data-cy="dataCySlug + '-altText-fld'"
        caption="Alt text"
      ></q-input>
    </div>
    <div class="row col-12 q-mt-md q-mb-sm">
      <span class="text-h6">Display text over the image</span>
    </div>
    <!-- Caption Options -->
    <div class="row col-12 q-pa-xs">
      <q-input
        outlined
        v-model="editorData.captionText"
        label="Overlay Text"
        class="col-12"
        :data-cy="dataCySlug + '-caption-fld'"
      ></q-input>
    </div>
    <div class="row col-12 q-pa-xs">
      <div class="col-7 q-pt-md text-body1">Position:</div>
      <div class="col-5">
        <q-select
          filled
          v-model="editorData.captionPosition"
          :options="captionPositionOptions"
          emit-value
          map-options
          dense
          options-dense
          :data-cy="dataCySlug + '-caption-position-select'"
        ></q-select>
      </div>
    </div>
    <div class="row col-12 q-pa-xs">
      <div class="col-7 q-pt-md text-body1">Font:</div>
      <div class="col-5">
        <q-select
          filled
          v-model="editorData.font"
          :options="fontOptions"
          emit-value
          map-options
          dense
          options-dense
          options-html
          :data-cy="dataCySlug + '-caption-font-select'"
        ></q-select>
      </div>
    </div>
    <div class="row col-12 q-pa-xs">
      <div class="col-7 q-pt-md text-body1">Font Size:</div>
      <div class="col-5">
        <q-select
          filled
          v-model="editorData.fontSize"
          :options="fontSizeOptions"
          emit-value
          map-options
          dense
          options-dense
          options-html
          :data-cy="dataCySlug + '-caption-font-size-select'"
        ></q-select>
      </div>
    </div>
    <div class="row col-12 q-pa-xs">
      <div class="col-7 q-pt-md text-body1">Font Style:</div>
      <div class="col-5">
        <q-select
          filled
          v-model="editorData.fontStyle"
          :options="fontStyleOptions"
          emit-value
          map-options
          dense
          options-dense
          options-html
          :data-cy="dataCySlug + '-caption-font-style-select'"
        ></q-select>
      </div>
    </div>
    <div class="row col-12 q-pa-xs">
      <div class="col-7 q-pt-md text-body1">Font Weight:</div>
      <div class="col-5">
        <q-select
          filled
          v-model="editorData.fontWeight"
          :options="fontWeightOptions"
          emit-value
          map-options
          dense
          options-dense
          options-html
          :data-cy="dataCySlug + '-caption-font-weight-select'"
        ></q-select>
      </div>
    </div>
    <div class="row col-12 q-pa-xs">
      <div class="col-7 q-pt-md text-body1">Font Color:</div>
      <div class="col-5">
        <q-input
          filled
          v-model="editorData.fontColor"
          :rules="['hexColor']"
          :data-cy="dataCySlug + '-caption-font-color-fld'"
        >
          <template v-slot:append>
            <q-icon name="colorize" class="cursor-pointer">
              <q-popup-proxy
                cover
                transition-show="scale"
                transition-hide="scale"
              >
                <q-color v-model="editorData.fontColor"></q-color>
              </q-popup-proxy>
            </q-icon>
          </template>
        </q-input>
      </div>
    </div>

    <!-- Control buttons -->
    <div class="row col-12">
      <q-space></q-space>
      <q-btn
        @click="emit('close')"
        class="subdued-btn"
        icon-right="mdi-close"
        flat
        size="sm"
        label="Close"
        :data-cy="dataCySlug + '-close-btn'"
      ></q-btn>
    </div>
  </div>
</template>

<script setup>
import { reactive, ref, watch } from "vue";
import { useQuasar } from "quasar";


import Fnt from "../Font.vue";

import ImgSourceDialog from "../dialogs/ImgSourceDialog.vue";
import UrlDialog from "../dialogs/UrlDialog.vue";
import UploadDialog from "../dialogs/UploadDialog.vue";

const props = defineProps({
  data: {
    type: [Object, null],
  },
  dataCySlug: {
    type: String,
    default: "img",
  },
  nuggetId: {
    type: String,
    default: null,
  },
});

const emit = defineEmits([
  "fileProvided",
  "notification",
]);

const $q = useQuasar();

let rawData = {
  imageSource: false,
  url: "",
  ratio: "1",
  fit: "scale-down",
  altText: "",
  captionText: "",
  captionPosition: "absolute-full text-subtitle2 flex flex-center",
  font: "Arial",
  fontSize: "xxx-large",
  fontStyle: "normal",
  fontWeight: "text-weight-regular",
  fontColor: "#ffffff",
};

if (props.data) {
  rawData = { ...props.data };
}

const editorData = reactive(rawData);


watch(editorData, (value) => {
  if (value) {
    emit("save", { newData: value });
  }
});

const displayUrl = ref(null);

if (props.data && props.data.url && props.data.url.startsWith("s3:")) {
  const [cruft, perm, key] = props.data.url.split(":");
  console.log(cruft);
  Storage.get(key, { level: perm }).then((s3Url) => {
    displayUrl.value = s3Url;
  });
}

// DIALOGS

const showUrlDialog = () => {
  $q.dialog({
    component: UrlDialog,

    // props forwarded to your custom component
    componentProps: {
      label: "Image URL",
    },
  })
    .onOk((providedUrl) => {
      editorData.url = providedUrl;
    })
    .onCancel(() => {
      console.log('canceled')
    })
    .onDismiss(() => {
      console.log(dismissed)
    });
};

const showImgSourceDialog = () => {
  $q.dialog({
    component: ImgSourceDialog,

    // props forwarded to your custom component
    componentProps: {
      nuggetId: props.nuggetId,
    },
  })
    .onOk((option) => {
      if (option.error) {
        emit("notification", {
          type: "error",
          message: "Save required before uploading.",
        });
      } else {
        switch (option.source) {
          case "url":
            editorData.imageSource = "url";
            showUrlDialog();
            break;
          case "upload":
            editorData.imageSource = "upload";
            showUploadDialog();
            break;
          case "camera":
            editorData.imageSource = "camera";
            showCameraOptions();
        }
      }
    })
    .onCancel(() => {
      console.log('canceled')
    })
    .onDismiss(() => {
      if (!editorData.imageSource) {
        emit("delete", true);
      }
    });
};

if (!editorData.imageSource) {
  showImgSourceDialog();
}

const uploadFile = async (file) => {
  try {
    const key = await Storage.put(
      "story/" + props.nuggetId + "/" + file.name,
      file,
      {
        level: "private",
        contentType: "text/plain",
      }
    );

    editorData.url = "s3:private:" + key.key;

    displayUrl.value = await Storage.get(key.key, { level: "private" });
  } catch (err) {
    console.log(err);
  }
};

// Option definitions below, code above //

const ratioOptions = [
  {
    label: "1 - original size",
    value: "1",
  },
  {
    label: "4/3 - fullscreen",
    value: "1.333",
  },
  {
    label: "16/9 - widescreen",
    value: "1.7777",
  },
];

const fitOptions = [
  {
    label: "Cover",
    value: "cover",
  },
  {
    label: "Fill",
    value: "fill",
  },
  {
    label: "Contain",
    value: "contain",
  },
  {
    label: "None",
    value: "none",
  },
  {
    label: "Scale Down",
    value: "scale-down",
  },
];

const captionPositionOptions = [
  {
    label: "Center",
    value: "absolute-full text-subtitle2 flex flex-center",
  },

  {
    label: "Top",
    value: "absolute-top text-center",
  },
  {
    label: "Top-left",
    value: "absolute-top-left",
  },
  {
    label: "Top-right",
    value: "absolute-top-right",
  },
  {
    label: "Bottom",
    value: "absolute-bottom text-subtitle1 text-center",
  },
  {
    label: "Bottom-left",
    value: "absolute-bottom-left text-subtitle2",
  },
  {
    label: "Bottom-right",
    value: "absolute-bottom-right text-subtitle2",
  },
];

const fontStyleOptions = [
  {
    label: "Normal",
    value: "Normal",
  },
  {
    label: "Italic",
    value: "Italic",
  },
];

const fontOptions = [
  {
    label: "<span style='font-family:Arial'>Arial</span>",
    value: "Arial",
  },
  {
    label: "<span style='font-family:Arial Black'>Arial Black</span>",
    value: "Arial Black",
  },
  {
    label: "<span style='font-family:Comic Sans MS'>Comic Sans MS</span>",
    value: "Comic Sans MS",
  },
  {
    label: "<span style='font-family:Courier New'>Courier New</span>",
    value: "Courier New",
  },
  {
    label: "<span style='font-family:Impact'>Impact</span>",
    value: "Impact",
  },
  {
    label: "<span style='font-family:Lucida Grande'>Lucida Grande</span>",
    value: "Lucida Grande",
  },
  {
    label: "<span style='font-family:Times New Roman'>Times New Roman</span>",
    value: "Times New Roman",
  },
  {
    label: "<span style='font-family:Verdana'>Verdana</span>",
    value: "Verdana",
  },
];

const fontSizeOptions = [
  {
    label: "XX-Small",
    value: "xx-small",
  },
  {
    label: "X-Small",
    value: "x-small",
  },
  {
    label: "Small",
    value: "small",
  },
  {
    label: "Normal",
    value: "medium",
  },
  {
    label: "Large",
    value: "large",
  },
  {
    label: "X-Large",
    value: "x-large",
  },
  {
    label: "XX-Large",
    value: "xx-large",
  },
  {
    label: "XXX-Large",
    value: "xxx-large",
  },
  {
    label: "Maximum",
    value: "fn-big",
  },
];

const fontWeightOptions = [
  {
    label: "<span class='text-weight-thin'>Thin</span>",
    value: "text-weight-thin",
  },
  {
    label: "<span class='text-weight-light'>Light</span>",
    value: "text-weight-light",
  },
  {
    label: "<span class='text-weight-regular'>Regular</span>",
    value: "text-weight-regular",
  },
  {
    label: "<span class='text-weight-medium'>Medium</span>",
    value: "text-weight-medium",
  },
  {
    label: "<span class='text-weight-bold'>Bold</span>",
    value: "text-weight-bold",
  },
  {
    label: "<span class='text-weight-bolder'>Bolder</span>",
    value: "text-weight-bolder",
  },
];
</script>

<style scoped lang="scss">
.xx-small {
  font-size: xx-small;
}

.x-small {
  font-size: x-small;
}

.small {
  font-size: small;
}
.medium {
  font-size: medium;
}
.large {
  font-size: large;
}
.x-large {
  font-size: x-large;
}
.xx-large {
  font-size: xx-large;
}
.xxx-large {
  font-size: xxx-large;
}
.fn-big {
  font-size: 5em;
}

.Italic {
  font-style: italic;
}

.Normal {
  font-style: normal;
}

.color-picker {
}
</style>
