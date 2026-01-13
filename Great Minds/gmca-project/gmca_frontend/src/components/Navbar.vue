<template>
  <nav class="bg-white shadow-md fixed w-full top-0 z-50">
    <div class="container mx-auto px-4 py-4 flex items-center justify-between">
      <router-link to="/">
        <!-- Logo + Text -->
        <div class="flex flex-col items-center leading-tight">
          <img
            src="/src/assets/images/gmca-logo.png"
            alt="GMCA Logo"
            class="w-12 h-12 object-contain"
          />
          <span
            class="text-[10px] font-medium text-gray-700 text-center mt-1 w-24"
          >
            Great Minds Christian Academy
          </span>
        </div>
      </router-link>

      <!-- Desktop Menu -->
      <ul class="hidden md:flex gap-8 text-gray-700 font-medium items-center">
        <li>
          <router-link
            to="/"
            class="nav-link flex items-center gap-2"
          >
            <i class="ri-home-4-line text-lg"></i>
            <span>Home</span>
          </router-link>
        </li>

        <li>
          <router-link
            to="/about"
            class="nav-link flex items-center gap-2"
          >
            <i class="ri-information-line text-lg"></i>
            <span>About</span>
          </router-link>
        </li>

        <li>
          <router-link
            to="/classes"
            class="nav-link flex items-center gap-2"
          >
            <i class="ri-book-open-line text-lg"></i>
            <span>Classes</span>
          </router-link>
        </li>

        <li>
          <router-link
            to="/enroll"
            class="nav-link flex items-center gap-2"
          >
            <i class="ri-user-add-line text-lg"></i>
            <span>Enroll</span>
          </router-link>
        </li>

        <li>
          <router-link
            to="/login"
            class="nav-link flex items-center gap-2"
          >
            <i class="ri-login-box-line text-lg"></i>
            <span>Login</span>
          </router-link>
        </li>
      </ul>


      <!-- Hamburger -->
      <button @click="toggleMenu" class="md:hidden focus:outline-none">
        <svg
          v-if="!open"
          class="w-7 h-7 text-gray-700"
          fill="none"
          stroke="currentColor"
          stroke-width="2"
          viewBox="0 0 24 24"
        >
          <path
            stroke-linecap="round"
            stroke-linejoin="round"
            d="M4 6h16M4 12h16M4 18h16"
          />
        </svg>

        <svg
          v-else
          class="w-7 h-7 text-gray-700"
          fill="none"
          stroke="currentColor"
          stroke-width="2"
          viewBox="0 0 24 24"
        >
          <path
            stroke-linecap="round"
            stroke-linejoin="round"
            d="M6 18L18 6M6 6l12 12"
          />
        </svg>
      </button>
    </div>

    <!-- Mobile Menu -->
    <transition name="slide">
      <ul
        v-if="open"
        class="md:hidden bg-white shadow-md px-6 py-6 mt-28 space-y-5 w-1/2 h-screen fixed top-0 left-0 flex flex-col items-start text-left"
      >
        <li>
          <router-link
            to="/"
            @click="closeMenu"
            class="nav-link flex items-center gap-3"
            exact
          >
            <i class="ri-home-4-line text-xl"></i> Home
          </router-link>
        </li>

        <li>
          <router-link
            to="/about"
            @click="closeMenu"
            class="nav-link flex items-center gap-3"
          >
            <i class="ri-information-line text-xl"></i> About
          </router-link>
        </li>

        <li>
          <router-link
            to="/classes"
            @click="closeMenu"
            class="nav-link flex items-center gap-3"
          >
            <i class="ri-book-open-line text-xl"></i> Classes
          </router-link>
        </li>

        <li>
          <router-link
            to="/enroll"
            @click="closeMenu"
            class="nav-link flex items-center gap-3"
          >
            <i class="ri-user-add-line text-xl"></i> Enroll
          </router-link>
        </li>

        <li>
          <router-link
            to="/login"
            @click="closeMenu"
            class="nav-link flex items-center gap-3"
          >
            <i class="ri-login-box-line text-xl"></i> Login
          </router-link>
        </li>
      </ul>
    </transition>
  </nav>
</template>

<script setup>
import { ref } from "vue";

const open = ref(false);

function toggleMenu() {
  open.value = !open.value;
}

function closeMenu() {
  open.value = false;
}
</script>

<style>
.nav-link {
  position: relative;
  padding-bottom: 6px;
  transition: color 0.2s ease;
}

.nav-link:hover {
  color: #2563eb; /* Tailwind blue-600 */
}

/* Active link underline */
.router-link-active {
  color: #2563eb; /* blue text and icon */
}

/* Slide-in animation */
.slide-enter-from {
  transform: translateX(-100%);
  opacity: 0;
}
.slide-enter-to {
  transform: translateX(0);
  opacity: 1;
}
.slide-enter-active {
  transition: all 0.3s ease-out;
}

.slide-leave-from {
  transform: translateX(0);
  opacity: 1;
}
.slide-leave-to {
  transform: translateX(-100%);
  opacity: 0;
}
.slide-leave-active {
  transition: all 0.25s ease-in;
}
</style>
