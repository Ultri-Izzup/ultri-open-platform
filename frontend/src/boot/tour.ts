import { boot } from 'quasar/wrappers';
import VueTour from 'vue-tour';

require('vue-tour/dist/vue-tour.css')

export default boot(({ app }) => {


  // Set i18n instance on app
  app.use(VueTour);
});
