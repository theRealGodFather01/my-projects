<template>
  <section class="py-16 md:px-6 bg-blue-50">
    <div class="container px-4 mx-auto grid md:grid-cols-2 gap-12 items-center">

      <div>
        <h2 class="text-3xl font-bold mb-4">Why Choose Us</h2>
        <p class="text-gray-700 mb-6">
          We focus on holistic growth: spiritually, mentally, and socially.
        </p>

        <ul class="space-y-3">
          <li
            v-for="(item, i) in reasons"
            :key="i"
            class="flex items-center gap-3"
          >
            <span class="text-blue-600 text-xl">✔</span>
            <span>{{ item }}</span>
          </li>
        </ul>
      </div>

      <div>
        <img src="" class="rounded-xl shadow-lg" />
      </div>

    </div>
  </section>
</template>

<script>
export default {
  props: {
    reasons: {
      type: Array,
      required: true,
    }
  }
};
</script>
