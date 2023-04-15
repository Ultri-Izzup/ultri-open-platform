import { defineConfig } from 'vitepress'

// https://vitepress.dev/reference/site-config
export default defineConfig({
  title: "Ultri Open Platform",
  description: "An open platform for scaling websites from PoC to mega-site.",
  themeConfig: {
    // https://vitepress.dev/reference/default-theme-config
    nav: [
      { text: 'Home', link: '/' },
      { text: 'Install', link: '/install/' },
      { text: 'Customize', link: '/customize/' },
      { text: 'Development', link: '/development/' }
    ],

    sidebar: [
      {
        text: 'Install',
        items: [
          { text: 'Prerequisites', link: '/install/prerequisites' },
          { text: 'Get code', link: '/install/get-code' }
          
        ]
      },
      {
        text: 'Customize',
        items: [
          { text: 'Color and Style', link: '/customize/color-and-style' },
          { text: 'Gateway Routes', link: '/customize/gateway' },
          { text: 'API Services', link: '/customize/api' },
          { text: 'User Interface', link: '/customize/frontend' },


          
        ]
      },
      {
        text: 'Development',
        items: [
          { text: 'New application', link: '/development/new-application' },
          { text: 'Contribute', link: '/development/contribute' }
          
        ]
      }
    ]
  ,

    socialLinks: [
      { icon: 'github', link: 'https://github.com/ultri-izzup/ultri-open-platform' }
    ]
  }
})
