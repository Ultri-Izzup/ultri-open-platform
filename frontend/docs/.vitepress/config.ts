import { defineConfig } from 'vitepress';

// https://vitepress.dev/reference/site-config
export default defineConfig({
  title: 'Izzup Membership Manual',
  description: 'Get the most out of membership',
  themeConfig: {
    // https://vitepress.dev/reference/default-theme-config
    nav: [
      { text: 'Home', link: '/' },
      { text: 'Free Membership', link: '/membership/' },
      { text: 'Accounts', link: '/accounts/' },
      { text: 'Applications', link: '/applications/' },
    ],

    sidebar: {
      '/membership': [
        {
          text: 'Membership',
          items: [
            { text: 'Benefits', link: '/membership/benefits' },
            { text: 'Costs', link: '/membership/costs' },
          ],
        },
      ],
      '/accounts': [
        {
          text: 'Accounts',
          items: [
            { text: 'Personal Account', link: '/accounts/personal-account' },
            { text: 'Premium Accounts', link: '/accounts/premium-accounts' },
            { text: 'Permissions', link: '/accounts/permissions' },
            { text: 'Roles', link: '/accounts/roles' },
            { text: 'Groups', link: '/accounts/groups' },
          ],
        },
      ],
      '/applications': [
        {
          text: 'Applications',
          items: [
            { text: 'Articles', link: '/applications/articles' },
            { text: 'Classifieds', link: '/applications/classifieds' },
          ],
        },
      ],
    },

    socialLinks: [
      {
        icon: 'github',
        link: 'https://github.com/ultri-izzup/ultri-open-platform',
      },
    ],
  },
});
