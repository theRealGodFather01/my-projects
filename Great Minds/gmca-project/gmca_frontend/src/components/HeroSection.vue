<template>
  <section class="relative min-h-screen w-full overflow-hidden">

    <!-- Background slideshow (responsive fix) -->
    <div class="absolute inset-0 w-full h-full overflow-hidden">
      <transition name="fade" mode="out-in">
        <img
          :key="currentImage"
          :src="currentImage"
          class="absolute inset-0 w-full h-full object-cover object-center"
        />
      </transition>
    </div>

    <!-- Pattern overlay -->
    <div
      class="absolute inset-0 bg-center bg-repeat opacity-50 pointer-events-none"
      :style="{ backgroundImage: `url(${bgPattern})` }"
    ></div>

    <!-- Content -->
    <div
      class="relative bg-white/80 w-full min-h-screen flex flex-col items-center justify-center p-6 text-center"
    >
      <img
        src="/src/assets/images/gmca-logo.png"
        alt="GMCA Logo"
        class="w-32 h-32 mb-4"
      />

      <h1 class="text-4xl md:text-6xl font-bold text-blue-700">
        Great Minds Christian Academy
      </h1>

      <p class="mt-4 text-lg md:text-2xl text-gray-700 max-w-xl">
        Raising godly, brilliant, creative, and excellent young minds.
      </p>

      <router-link
        to="/about"
        class="mt-6 px-6 py-3 bg-blue-700 text-white text-lg rounded-lg hover:bg-blue-800 transition inline-block"
      >
        Learn More
      </router-link>
    </div>

  </section>
</template>

<script setup>
import { ref, onMounted } from "vue"
import bgPattern from "@/assets/images/uniform-pattern.png"

const images = [
  "/src/assets/images/slide1.jpg",
  "/src/assets/images/slide2.jpg",
  "/src/assets/images/slide3.jpg",
]

const currentImage = ref(images[0])
let index = 0

onMounted(() => {
  setInterval(() => {
    index = (index + 1) % images.length
    currentImage.value = images[index]
  }, 4000)
})
</script>

<style>
.fade-enter-active, .fade-leave-active {
  transition: opacity 1.5s ease;
}
.fade-enter-from, .fade-leave-to {
  opacity: 0;
}
</style>
