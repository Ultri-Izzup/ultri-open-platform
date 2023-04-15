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
          { text: 'Roadmap', link: '/development/roadmap' },
          { text: 'New application', link: '/development/new-application' },
          { text: 'Contribute', link: '/development/contribute' },
          { text: 'Swagger', link: '/development/swagger' }          
        ]
      },
      {
        text: 'Technical Support',
        items: [
          { text: 'Repository Structure', link: '/platform/repository' },
          { text: 'Docker', link: '/platform/docker' },
          { text: 'Authentication', link: '/platform/authentication' },
          { text: 'Authorization', link: '/platform/authorization' },
          { text: 'Gateway Server', link: '/platform/gateway' },
          { text: 'Nugget API', link: '/platform/nugget-api' },
          { text: 'Front End', link: '/platform/frontend' },
          { text: 'Security', link: '/platform/security' },
          { text: 'Postgres', link: '/platform/postgres' },
          { text: 'Redis', link: '/platform/redis' },
          { text: 'Contact Support', link: '/platform/support' },
        ]
      }
    ]
  ,

    socialLinks: [
      { icon: 'github', link: 'https://github.com/ultri-izzup/ultri-open-platform' },
      { icon: 'facebook', link: 'https://www.facebook.com/OpenSourceBike/' },
      { icon: 'linkedin', link: 'https://www.linkedin.com/company/open-source-bike' }
    ]
  }
})
