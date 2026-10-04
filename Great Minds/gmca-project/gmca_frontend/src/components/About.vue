<template>
  <section class="py-20 bg-gray-50 relative overflow-hidden">

    <!-- Decorative tech circles -->
    <div class="absolute top-10 left-10 w-24 h-24 bg-blue-100 rounded-full blur-xl opacity-40"></div>
    <div class="absolute bottom-16 right-16 w-32 h-32 bg-yellow-100 rounded-full blur-xl opacity-40"></div>

    <div class="container mx-auto grid md:grid-cols-2 gap-14 items-center relative z-10">

      <!-- IMAGE SIDE -->
      <div class="relative">

        <!-- Floating shape behind the image -->
        <div class="absolute inset-0 bg-gradient-to-br from-blue-200 to-blue-50 rounded-3xl -rotate-3 opacity-70"></div>

        <img 
          src="/src/assets/images/gmca-logo.png"
          alt="GMCA Logo"
          class="relative z-10 w-full rounded-3xl shadow-xl border border-gray-200 bg-white p-6"
        />

        <!-- Floating school-themed icon -->
        <div class="absolute -top-6 -right-6 bg-white shadow-lg p-4 rounded-full border border-gray-200 z-20">
          <i class="ri-graduation-cap-fill text-blue-600 text-2xl"></i>
        </div>
      </div>

      <!-- TEXT SIDE -->
      <div>
        <h2 class="text-4xl font-extrabold text-gray-900 leading-tight mb-4">
          Building <span class="text-blue-600">Great Minds</span>
          for a Greater Future.
        </h2>

        <p class="text-gray-600 text-lg leading-relaxed mb-7">
          Great Minds Christian Academy blends <span class="font-semibold text-blue-700">
          modern digital learning</span> with strong moral and academic foundations.
          Our classrooms, mentorship, and programs are designed to prepare students 
          for excellence in a rapidly changing world.
        </p>

        <!-- Tech-style info cards -->
        <div class="grid grid-cols-2 gap-6 mb-10">

          <div class="p-5 bg-white rounded-xl shadow-md border border-gray-100">
            <div class="w-10 h-10 bg-blue-100 text-blue-600 flex items-center justify-center rounded-lg mb-2">
              <i class="ri-book-open-line text-xl"></i>
            </div>
            <p class="font-semibold text-gray-800">Modern Curriculum</p>
            <p class="text-gray-600 text-sm">Tech-friendly learning approach</p>
          </div>

          <div class="p-5 bg-white rounded-xl shadow-md border border-gray-100">
            <div class="w-10 h-10 bg-yellow-100 text-yellow-600 flex items-center justify-center rounded-lg mb-2">
              <i class="ri-team-fill text-xl"></i>
            </div>
            <p class="font-semibold text-gray-800">Friendly Community</p>
            <p class="text-gray-600 text-sm">Safe and inspiring environment</p>
          </div>

        </div>

        <button 
          class="px-8 py-3 bg-blue-600 text-white font-bold rounded-lg shadow-md hover:bg-blue-700 transition-all">
          Learn More →
        </button>
      </div>

    </div>
  </section>
</template>
