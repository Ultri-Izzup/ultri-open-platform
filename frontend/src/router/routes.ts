import { RouteRecordRaw } from 'vue-router';

const routes: RouteRecordRaw[] = [
  {
    path: '/',
    component: () => import('layouts/MainLayout.vue'),
    children: [{ path: '', component: () => import('pages/IndexPage.vue') }],
  },

  {
    path: '/member',
    component: () => import('layouts/MainLayout.vue'),
    children: [{ path: '', component: () => import('src/services/member/pages/DashboardPage.vue') }],
    meta: {
      requiresAuth: true,
    },
  },

  {
    path: '/member/settings',
    component: () => import('layouts/MainLayout.vue'),
    children: [{ path: '', component: () => import('src/services/member/pages/SettingsPage.vue') }],
    meta: {
      requiresAuth: true,
    },
  },

  // Always leave this as last one,
  // but you can also remove it
  {
    path: '/:catchAll(.*)*',
    component: () => import('pages/ErrorNotFound.vue'),
  },
];

export default routes;
