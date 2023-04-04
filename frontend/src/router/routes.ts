import { RouteRecordRaw } from 'vue-router';

const routes: RouteRecordRaw[] = [
  {
    path: '/',
    component: () => import('layouts/MainLayout.vue'),
    children: [{ path: '', component: () => import('pages/IndexPage.vue'), name: 'root' }],
  },

  {
    path: '/member',
    component: () => import('layouts/MainLayout.vue'),
    children: [{ path: '', component: () => import('src/services/member/pages/DashboardPage.vue'), name: 'member-dashboard' }],
    meta: {
      requiresAuth: true,
    },
  },

  {
    path: '/member/settings',
    component: () => import('layouts/MainLayout.vue'),
    children: [{ path: '', component: () => import('src/services/member/pages/SettingsPage.vue'), name: 'member-settings' }],
    meta: {
      requiresAuth: true,
    },
  },

  {
    path: '/member/articles',
    component: () => import('layouts/MainLayout.vue'),
    children: [{ path: '', component: () => import('src/services/article/pages/ArticlesPage.vue'), name: 'member-articles' }],
    meta: {
      requiresAuth: true,
    },
  },

  {
    path: '/article/new',
    component: () => import('layouts/MainLayout.vue'),
    children: [{ path: '', component: () => import('src/services/article/pages/NewArticlePage.vue'), name: 'new-article' }],
    meta: {

    },
  },

  {
    path: '/member/posts',
    component: () => import('layouts/MainLayout.vue'),
    children: [{ path: '', component: () => import('src/services/post/pages/PostsPage.vue'), name: 'member-posts' }],
    meta: {
      requiresAuth: true,
    },
  },

  {
    path: '/groups',
    component: () => import('layouts/MainLayout.vue'),
    children: [{ path: '', component: () => import('src/services/groups/pages/GroupsPage.vue'), name: 'groups' }],
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
