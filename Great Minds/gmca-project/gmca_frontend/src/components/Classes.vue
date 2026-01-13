<template>
  <section class="py-16">
    <div class="container mx-auto text-center">

      <h2 class="text-3xl font-bold mb-3">Our Classes</h2>
      <p class="text-gray-600 mb-10">
        Explore our programs designed to help your child / ward grow.
      </p>

      <div class="grid sm:grid-cols-2 md:grid-cols-3 gap-8">

        <div
          v-for="(cls, idx) in classes"
          :key="idx"
          class="bg-white p-6 rounded-xl shadow hover:shadow-lg transition"
        >
          <img :src="cls.image" class="rounded-lg mb-4" />
          <h3 class="text-xl font-semibold mb-2">{{ cls.title }}</h3>
          <p class="text-gray-600 mb-4">{{ cls.description }}</p>
          <button class="text-blue-600 font-medium hover:underline">View More</button>
        </div>

      </div>

    </div>
  </section>
</template>

<script>
export default {
  props: {
    classes: {
      type: Array,
      required: true,
    }
  }
};
</script>
