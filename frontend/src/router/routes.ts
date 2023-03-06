import { RouteRecordRaw } from 'vue-router';

const routes: RouteRecordRaw[] = [
  {
    path: '/',
    name: 'root',
    component: () => import('layouts/MainLayout.vue'),
    children: [{ path: '', component: () => import('pages/IndexPage.vue') }],
  },

  {
    path: '/member',
    name: 'member-dashboard',
    component: () => import('layouts/MainLayout.vue'),
    children: [{ path: '', component: () => import('src/services/member/pages/DashboardPage.vue') }],
    meta: {
      requiresAuth: true,
    },
  },

  {
    path: '/member/settings',
    name: 'member-settings',
    component: () => import('layouts/MainLayout.vue'),
    children: [{ path: '', component: () => import('src/services/member/pages/SettingsPage.vue') }],
    meta: {
      requiresAuth: true,
    },
  },

  {
    path: '/member/articles',
    name: 'member-articles',
    component: () => import('layouts/MainLayout.vue'),
    children: [{ path: '', component: () => import('src/services/article/pages/ArticlesPage.vue') }],
    meta: {
      requiresAuth: true,
    },
  },

  {
    path: '/new/article',
    name: 'new-article',
    component: () => import('layouts/MainLayout.vue'),
    children: [{ path: '', component: () => import('src/services/article/pages/EditorPage.vue') }],
    meta: {

    },
  },

  {
    path: '/member/posts',
    name: 'member-posts',
    component: () => import('layouts/MainLayout.vue'),
    children: [{ path: '', component: () => import('src/services/post/pages/SettingsPage.vue') }],
    meta: {
      requiresAuth: true,
    },
  },

  {
    path: '/groups',
    name: 'groups',
    component: () => import('layouts/MainLayout.vue'),
    children: [{ path: '', component: () => import('src/services/groups/pages/GroupsPage.vue') }],
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
