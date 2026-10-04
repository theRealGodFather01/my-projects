<template>
  <section class="min-h-screen flex items-center justify-center bg-gray-50 px-4">
    <div class="max-w-4xl w-full">
      <!-- Heading -->
      <div class="text-center mb-10">
        <h1 class="text-3xl font-bold text-gray-800">
          Portal Login
        </h1>
        <p class="text-gray-600 mt-2">
          Select your portal to continue
        </p>
      </div>

      <!-- Cards -->
      <div class="grid gap-6 md:grid-cols-3">
        <!-- Admin -->
        <router-link
          to="/portal/admin"
          class="group bg-white rounded-2xl shadow hover:shadow-xl transition p-8 text-center"
        >
          <div
            class="w-16 h-16 mx-auto flex items-center justify-center rounded-full bg-blue-100 text-blue-600 mb-4 group-hover:scale-110 transition"
          >
            <i class="ri-shield-user-line text-3xl"></i>
          </div>

          <h2 class="text-xl font-semibold text-gray-800 mb-2">
            Admin Portal
          </h2>
          <p class="text-gray-600 text-sm mb-4">
            School management and administration
          </p>

          <span class="text-blue-600 font-medium">
            Login →
          </span>
        </router-link>

        <!-- Teacher -->
        <router-link
          to="/portal/teacher"
          class="group bg-white rounded-2xl shadow hover:shadow-xl transition p-8 text-center"
        >
          <div
            class="w-16 h-16 mx-auto flex items-center justify-center rounded-full bg-green-100 text-green-600 mb-4 group-hover:scale-110 transition"
          >
            <i class="ri-graduation-cap-line text-3xl"></i>
          </div>

          <h2 class="text-xl font-semibold text-gray-800 mb-2">
            Teacher Portal
          </h2>
          <p class="text-gray-600 text-sm mb-4">
            Classroom and academic tools
          </p>

          <span class="text-green-600 font-medium">
            Login →
          </span>
        </router-link>

        <!-- Student -->
        <router-link
          to="/portal/student"
          class="group bg-white rounded-2xl shadow hover:shadow-xl transition p-8 text-center"
        >
          <div
            class="w-16 h-16 mx-auto flex items-center justify-center rounded-full bg-purple-100 text-purple-600 mb-4 group-hover:scale-110 transition"
          >
            <i class="ri-user-line text-3xl"></i>
          </div>

          <h2 class="text-xl font-semibold text-gray-800 mb-2">
            Student Portal
          </h2>
          <p class="text-gray-600 text-sm mb-4">
            Access lessons and learning resources
          </p>

          <span class="text-purple-600 font-medium">
            Login →
          </span>
        </router-link>
      </div>
    </div>
  </section>
</template>
