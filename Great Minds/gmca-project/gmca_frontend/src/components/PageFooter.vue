<template>
  <footer class="bg-gray-900 text-gray-300 py-12 px-6 items-center">
    <div class="container mx-auto grid grid-cols-2 sm:grid-cols-2 md:grid-cols-4 gap-10 items-center">

      <div class="flex flex-col text-center">
        <img
          src="/src/assets/images/gmca-logo.png"
          alt="GMCA Logo"
          class="w-12 h-12 object-contain mx-11"
        />
        <p class="mt-3 text-gray-400 w-35">
          Great Minds Christian Academy.
        </p>
      </div>

      <!-- QUICK LINKS -->
      <div>
        <h4 class="text-white font-semibold mb-3">Quick Links</h4>
        <ul class="space-y-2">
          <li>
            <router-link
              to="/"
              class="hover:text-white"
            >
              Home
            </router-link>
          </li>

          <li>
            <router-link
              to="/about"
              class="hover:text-white"
            >
              About
            </router-link>
          </li>

          <li>
            <router-link
              to="/classes"
              class="hover:text-white"
            >
              Classes
            </router-link>
          </li>

          <li>
            <router-link
              to="/login"
              class="hover:text-white"
            >
              Login
            </router-link>
          </li>

        </ul>
      </div>

      <!-- CONTACT -->
      <div>
        <h4 class="text-white font-semibold mb-3">Contact</h4>
        <p>Email: info@gmca.com</p>
        <p>Phone: +234 000 0000 000</p>
      </div>

      <!-- SOCIAL -->
      <div>
        <h4 class="text-white font-semibold mb-3">Follow Us</h4>
        <div class="flex gap-4">
          <i class="ri-facebook-fill text-xl hover:text-white"></i>
          <i class="ri-instagram-fill text-xl hover:text-white"></i>
        </div>
      </div>
    </div>

    <div class="text-center text-gray-500 mt-10">
      © 2025 Great Minds Christian Academy. All Rights Reserved.
    </div>
  </footer>
</template>
