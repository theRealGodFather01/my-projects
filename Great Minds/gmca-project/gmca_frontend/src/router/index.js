import { createRouter, createWebHistory } from "vue-router";
import Home from "@/views/Home.vue";
import About from "@/views/About.vue";
import Classes from "@/views/Classes.vue";
import Enroll from "@/views/Enroll.vue";
import Login from "@/views/Login.vue";

const routes = [
    {
      path: "/",
      component: () => import("@/views/Home.vue"),
      meta: {
        title: "Home | Great Minds Christian Academy",
        description:
          "Great Minds Christian Academy – raising godly, brilliant, creative, and excellent young minds through modern digital learning.",
      },
    },
  
    {
      path: "/about",
      component: () => import("@/views/About.vue"),
      meta: {
        title: "About Us | Great Minds Christian Academy",
        description:
          "Learn about Great Minds Christian Academy, our vision, teachers, and programs focused on raising godly and excellent young minds.",
      },
    },
  
    {
      path: "/classes",
      component: () => import("@/views/Classes.vue"),
      meta: {
        title: "Our Classes | Great Minds Christian Academy",
        description:
          "Explore our Kindergarten and Primary school classes designed to nurture faith, creativity, and academic excellence.",
      },
    },
  
    {
      path: "/enroll",
      component: () => import("@/views/Enroll.vue"),
      meta: {
        title: "Enroll Your Child | Great Minds Christian Academy",
        description:
          "Begin your child’s journey at Great Minds Christian Academy. Enroll today and build a strong foundation for the future.",
      },
    },
  
    {
      path: "/login",
      component: () => import("@/views/Login.vue"),
      meta: {
        title: "Portal Login | Great Minds Christian Academy",
        description:
          "Access the Great Minds Christian Academy portal. Secure login for administrators, teachers, and students.",
      },
    },
  
    /* Role-based portals (recommended) */
    {
      path: "/portal/admin",
      component: () => import("@/views/portal/AdminLogin.vue"),
      meta: {
        title: "Admin Portal | GMCA",
        description:
          "Administrator portal for managing Great Minds Christian Academy.",
      },
    },
  
    {
      path: "/portal/teacher",
      component: () => import("@/views/portal/TeacherLogin.vue"),
      meta: {
        title: "Teacher Portal | GMCA",
        description:
          "Teacher portal for academic management and classroom resources.",
      },
    },
  
    {
      path: "/portal/student",
      component: () => import("@/views/portal/StudentLogin.vue"),
      meta: {
        title: "Student Portal | GMCA",
        description:
          "Student portal for accessing learning resources and academic progress.",
      },
    },
  ];
  
  const router = createRouter({
    history: createWebHistory(),
    routes,
  });

  /* AOS refresh after every route change */
  router.afterEach(() => {
    AOS.refreshHard();
  });
  
  /* SEO: Auto-update page title + meta description */
  router.afterEach((to) => {
    document.title = to.meta.title || "Great Minds Christian Academy";
  
    const description = document.querySelector(
      'meta[name="description"]'
    );
  
    if (description && to.meta.description) {
      description.setAttribute("content", to.meta.description);
    }
  });
  
  export default router;