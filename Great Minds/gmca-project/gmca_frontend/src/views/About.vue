<template>
  <!-- PAGE WRAPPER -->
  <div class="relative min-h-screen w-full overflow-hidden">
    <!-- BACKGROUND FADE-IN CAROUSEL (FULL PAGE) -->
    <div class="absolute inset-0 w-full h-full overflow-hidden">
      <transition name="fade" mode="out-in">
        <img
          :key="currentImage"
          :src="currentImage"
          class="absolute inset-0 w-full h-full object-cover object-center"
          alt="About background"
        />
      </transition>
    </div>

    <!-- PATTERN OVERLAY -->
    <div
      class="absolute inset-0 bg-center bg-repeat opacity-50 pointer-events-none"
      :style="{ backgroundImage: `url(${bgPattern})` }"
    ></div>

    <!-- DARK OVERLAY -->
    <div class="absolute inset-0 bg-black/60"></div>

    <!-- PAGE CONTENT -->
    <div class="relative z-10 w-full">
      <!-- HERO -->
      <section class="flex items-center justify-center pt-[15vh]">
        <div
          class="w-full bg-blue-900/20 backdrop-blur-lg text-white py-20 shadow-xl"
          data-aos="fade-up"
        >
          <div class="max-w-4xl mx-auto px-6 text-center">
            <h1 class="text-4xl md:text-5xl font-bold mb-4">
              Great Minds Christian Academy
            </h1>

            <p class="text-lg md:text-xl text-blue-200 mb-6">
              Raising godly, brilliant, creative, and excellent young minds.
            </p>

            <router-link
              to="/enroll"
              class="inline-block bg-blue-600 hover:bg-blue-700 text-white px-8 py-3 rounded-full font-semibold transition"
            >
              Enroll Now
            </router-link>
          </div>
        </div>
      </section>

      <!-- INTRO / ABOUT ARTICLE -->
      <section class="flex items-center justify-center">
        <div
          class="w-full mx-auto bg-blue-200/70 backdrop-blur-lg p-12 md:p-16 shadow-xl text-center"
          data-aos="fade-up"
          data-aos-delay="100"
        >
          <h2 class="text-3xl md:text-4xl font-bold text-blue-700 mb-4">
            Building Great Minds for a Greater Future
          </h2>

          <p class="text-gray-700 text-lg leading-relaxed mb-6">
            Great Minds Christian Academy blends modern digital learning with
            strong moral and academic foundations. Our classrooms, mentorship,
            and programs are carefully designed to prepare students for
            excellence in a rapidly changing world.
          </p>

          <p class="text-gray-700 text-lg leading-relaxed">
            We are dedicated to raising godly, brilliant, creative, and
            excellent young minds through a balanced approach that nurtures
            character, creativity, and confidence from an early age.
          </p>
        </div>
      </section>

      <!-- CORE VALUES -->
      <section class="flex items-center justify-center">
        <div
          class="w-full bg-blue-900/15 backdrop-blur-lg text-white py-24 shadow-xl"
          data-aos="fade-up"
        >
          <div class="max-w-6xl mx-auto px-6 text-center">
            <!-- Section Title -->
            <h2 class="text-3xl md:text-4xl font-bold mb-4">Our Core Values</h2>

            <p class="text-lg text-blue-200 max-w-3xl mx-auto mb-14">
              We focus on holistic growth — spiritually, mentally, and socially
              — ensuring every child learns, grows, and thrives in a safe and
              inspiring environment.
            </p>

            <!-- Values Grid -->
            <div class="grid gap-8 md:grid-cols-3">
              <!-- Modern Curriculum -->
              <div
                class="bg-white/85 backdrop-blur-md rounded-2xl p-8 shadow-lg text-gray-800"
                data-aos="fade-up"
              >
                <i class="ri-computer-line text-4xl text-blue-700 mb-4"></i>
                <h3 class="text-xl font-semibold mb-3">Modern Curriculum</h3>
                <p class="text-gray-600">
                  A tech-friendly learning approach designed to prepare students
                  for the future through creativity, innovation, and critical
                  thinking.
                </p>
              </div>

              <!-- Friendly Community -->
              <div
                class="bg-white/85 backdrop-blur-md rounded-2xl p-8 shadow-lg text-gray-800"
                data-aos="fade-up"
                data-aos-delay="100"
              >
                <i class="ri-group-line text-4xl text-blue-700 mb-4"></i>
                <h3 class="text-xl font-semibold mb-3">Friendly Community</h3>
                <p class="text-gray-600">
                  A nurturing and inclusive environment where children feel
                  supported, valued, and encouraged to be their best.
                </p>
              </div>

              <!-- Safe Environment -->
              <div
                class="bg-white/85 backdrop-blur-md rounded-2xl p-8 shadow-lg text-gray-800"
                data-aos="fade-up"
                data-aos-delay="200"
              >
                <i class="ri-shield-check-line text-4xl text-blue-700 mb-4"></i>
                <h3 class="text-xl font-semibold mb-3">Safe Environment</h3>
                <p class="text-gray-600">
                  Secure and inspiring learning spaces that build confidence,
                  promote well-being, and allow every child to flourish.
                </p>
              </div>
            </div>
          </div>
        </div>
      </section>

      <!-- CLASSES OVERVIEW / WHAT WE OFFER -->
      <section class="flex items-center justify-center">
        <div
          class="w-full bg-blue-200/70 backdrop-blur-lg p-14 md:p-20 shadow-xl"
          data-aos="fade-up"
        >
          <div class="max-w-6xl mx-auto text-center px-6">
            <!-- Section Heading -->
            <h2 class="text-3xl md:text-4xl font-bold text-blue-700 mb-4">
              Our Classes & What We Offer
            </h2>

            <p
              class="text-gray-700 text-lg leading-relaxed max-w-4xl mx-auto mb-12"
            >
              Our programs are thoughtfully designed to nurture academic
              excellence, godly character, creativity, and digital skills at
              every stage of a child’s development.
            </p>

            <!-- WHAT WE OFFER -->
            <h2 class="text-3xl md:text-4xl font-bold text-blue-700 mb-4">
              What We Offer
            </h2>
            <div class="grid md:grid-cols-3 gap-8 mb-20">
              <div
                class="bg-white/80 backdrop-blur-md rounded-2xl p-8 shadow-lg"
                data-aos="fade-up"
              >
                <i class="ri-book-2-line text-4xl text-blue-700 mb-4"></i>
                <h3 class="text-xl font-semibold mb-3">Quality Education</h3>
                <p class="text-gray-600">
                  A balanced curriculum that builds strong literacy, numeracy,
                  and critical thinking skills.
                </p>
              </div>

              <div
                class="bg-white/80 backdrop-blur-md rounded-2xl p-8 shadow-lg"
                data-aos="fade-up"
                data-aos-delay="100"
              >
                <i class="ri-heart-line text-4xl text-blue-700 mb-4"></i>
                <h3 class="text-xl font-semibold mb-3">
                  Moral & Spiritual Training
                </h3>
                <p class="text-gray-600">
                  Christian values integrated into daily learning, shaping
                  discipline and godly character.
                </p>
              </div>

              <div
                class="bg-white/80 backdrop-blur-md rounded-2xl p-8 shadow-lg"
                data-aos="fade-up"
                data-aos-delay="200"
              >
                <i class="ri-computer-line text-4xl text-blue-700 mb-4"></i>
                <h3 class="text-xl font-semibold mb-3">Digital Skills</h3>
                <p class="text-gray-600">
                  Early exposure to technology, creativity, and problem-solving
                  skills.
                </p>
              </div>
            </div>

            <!-- CLASSES OVERVIEW -->
            <h2 class="text-3xl md:text-4xl font-bold text-blue-700 mb-4">
              Our Classes
            </h2>
            <div class="grid sm:grid-cols-2 md:grid-cols-3 gap-8">
              <div class="bg-white/85 backdrop-blur rounded-xl p-6 shadow">
                <h4 class="font-semibold text-blue-700 text-lg mb-2">
                  Kindergarten
                </h4>
                <p class="text-gray-600">
                  Building faith, confidence, and character in the next
                  generation.
                </p>
              </div>

              <div class="bg-white/85 backdrop-blur rounded-xl p-6 shadow">
                <h4 class="font-semibold text-blue-700 text-lg mb-2">
                  Grade 1
                </h4>
                <p class="text-gray-600">
                  Class of Great Intellectuals — laying strong academic
                  foundations.
                </p>
              </div>

              <div class="bg-white/85 backdrop-blur rounded-xl p-6 shadow">
                <h4 class="font-semibold text-blue-700 text-lg mb-2">
                  Grade 2
                </h4>
                <p class="text-gray-600">
                  Class of Creative Innovators — encouraging imagination and
                  curiosity.
                </p>
              </div>

              <div class="bg-white/85 backdrop-blur rounded-xl p-6 shadow">
                <h4 class="font-semibold text-blue-700 text-lg mb-2">
                  Grade 3
                </h4>
                <p class="text-gray-600">
                  Class of Pacesetters — developing leadership and confidence.
                </p>
              </div>

              <div class="bg-white/85 backdrop-blur rounded-xl p-6 shadow">
                <h4 class="font-semibold text-blue-700 text-lg mb-2">
                  Grade 4
                </h4>
                <p class="text-gray-600">
                  Class of Shooting Stars — sharpening skills and independence.
                </p>
              </div>

              <div class="bg-white/85 backdrop-blur rounded-xl p-6 shadow">
                <h4 class="font-semibold text-blue-700 text-lg mb-2">
                  Grade 5
                </h4>
                <p class="text-gray-600">
                  Class of Champions — preparing for excellence and leadership.
                </p>
              </div>
            </div>
          </div>
        </div>
      </section>

      <!-- MEET OUR TEACHERS -->
      <section class="flex items-center justify-center">
        <div
          class="w-full bg-blue-900/20 backdrop-blur-lg py-20 shadow-xl"
          data-aos="fade-up"
        >
          <div class="max-w-6xl mx-auto px-6 text-center text-white">
            <!-- Heading -->
            <h2 class="text-4xl md:text-5xl font-bold mb-4">
              Meet Our Teachers
            </h2>

            <p class="text-lg md:text-xl text-blue-200 max-w-3xl mx-auto mb-14">
              Our dedicated mentors are passionate about nurturing academic
              excellence, godly character, and creativity in every child.
            </p>

            <!-- Teachers Grid -->
            <div class="grid sm:grid-cols-2 md:grid-cols-3 gap-10">
              <!-- Teacher Card -->
              <div
                class="bg-white/85 backdrop-blur-md rounded-2xl p-8 shadow-lg text-center text-gray-800"
                data-aos="fade-up"
              >
                <img
                  src="@/assets/images/portrait_placeholder.png"
                  alt="Teacher"
                  class="w-28 h-28 mx-auto rounded-full object-cover mb-4"
                />
                <h3 class="text-lg font-semibold">Mrs. Grace Johnson</h3>
                <p class="text-blue-600 text-sm mb-2">Head Teacher</p>
                <p class="text-gray-600 text-sm">
                  Passionate about guiding young minds with wisdom, discipline,
                  and excellence.
                </p>
              </div>

              <div
                class="bg-white/85 backdrop-blur-md rounded-2xl p-8 shadow-lg text-center text-gray-800"
                data-aos="fade-up"
                data-aos-delay="100"
              >
                <img
                  src="@/assets/images/portrait_placeholder.png"
                  alt="Teacher"
                  class="w-28 h-28 mx-auto rounded-full object-cover mb-4"
                />
                <h3 class="text-lg font-semibold">Mr. Daniel Ade</h3>
                <p class="text-blue-600 text-sm mb-2">STEM Educator</p>
                <p class="text-gray-600 text-sm">
                  Inspiring innovation, problem-solving, and digital creativity.
                </p>
              </div>

              <div
                class="bg-white/85 backdrop-blur-md rounded-2xl p-8 shadow-lg text-center text-gray-800"
                data-aos="fade-up"
                data-aos-delay="200"
              >
                <img
                  src="@/assets/images/portrait_placeholder.png"
                  alt="Teacher"
                  class="w-28 h-28 mx-auto rounded-full object-cover mb-4"
                />
                <h3 class="text-lg font-semibold">Mrs. Esther Obi</h3>
                <p class="text-blue-600 text-sm mb-2">Early Years Mentor</p>
                <p class="text-gray-600 text-sm">
                  Building strong foundations through care, creativity, and
                  faith.
                </p>
              </div>
            </div>
          </div>
        </div>
      </section>

      <!-- CEO / FOUNDER SPOTLIGHT -->
      <section class="flex items-center justify-center">
        <div
          class="w-full bg-blue-200/70 backdrop-blur-lg p-14 md:p-20 shadow-xl"
          data-aos="fade-up"
        >
          <div
            class="max-w-5xl mx-auto px-6 grid md:grid-cols-2 gap-12 items-center"
          >
            <!-- CEO Image -->
            <div class="flex justify-center md:justify-end">
              <img
                src="@/assets/images/portrait_placeholder.png"
                alt="Founder & CEO"
                class="w-52 h-52 md:w-64 md:h-64 rounded-full object-cover shadow-2xl border-4 border-white/60"
              />
            </div>

            <!-- CEO Message -->
            <div class="text-center md:text-left">
              <h2 class="text-3xl md:text-4xl font-bold text-blue-700 mb-3">
                Meet Our Founder & CEO
              </h2>

              <p class="text-blue-600 font-semibold mb-6">Mrs. [CEO Name]</p>

              <p class="text-gray-700 text-lg leading-relaxed mb-6">
                Our vision is to raise a generation of children who are
                spiritually grounded, intellectually sound, and prepared to lead
                with integrity in a rapidly changing world.
              </p>

              <p class="text-gray-700 text-lg leading-relaxed">
                At Great Minds Christian Academy, we believe education is more
                than academics — it is about shaping character, nurturing
                purpose, and unlocking every child’s God-given potential.
              </p>
            </div>
          </div>
        </div>
      </section>

      <!-- WHY CHOOSE US -->
      <section class="flex items-center justify-center">
        <div
          class="w-full bg-blue-900/20 backdrop-blur-lg text-white py-24 shadow-xl"
          data-aos="fade-up"
        >
          <div class="max-w-6xl mx-auto px-6 text-center">
            <!-- Heading -->
            <h2 class="text-4xl md:text-5xl font-bold mb-6">Why Choose Us</h2>

            <p class="text-lg md:text-xl text-blue-200 mb-14 max-w-3xl mx-auto">
              We focus on holistic growth — spiritually, mentally, socially, and
              academically — ensuring every child is prepared for the future.
            </p>

            <!-- Reasons Grid -->
            <div class="grid md:grid-cols-3 gap-8">
              <!-- Item -->
              <div
                class="bg-white/10 backdrop-blur-md p-8 rounded-2xl shadow-lg"
              >
                <i class="ri-group-line text-4xl text-blue-300 mb-4"></i>
                <h3 class="text-xl font-semibold mb-3">
                  Strong Community Culture
                </h3>
                <p class="text-blue-100">
                  A supportive, faith-driven environment where children feel
                  valued and inspired to grow.
                </p>
              </div>

              <!-- Item -->
              <div
                class="bg-white/10 backdrop-blur-md p-8 rounded-2xl shadow-lg"
              >
                <i class="ri-user-heart-line text-4xl text-blue-300 mb-4"></i>
                <h3 class="text-xl font-semibold mb-3">
                  Dedicated Mentors & Teachers
                </h3>
                <p class="text-blue-100">
                  Passionate educators committed to nurturing both academic
                  excellence and character development.
                </p>
              </div>

              <!-- Item -->
              <div
                class="bg-white/10 backdrop-blur-md p-8 rounded-2xl shadow-lg"
              >
                <i class="ri-leaf-line text-4xl text-blue-300 mb-4"></i>
                <h3 class="text-xl font-semibold mb-3">Holistic Development</h3>
                <p class="text-blue-100">
                  Balanced learning that nurtures spiritual growth, creativity,
                  confidence, and leadership.
                </p>
              </div>
            </div>

            <!-- CTA -->
            <div class="mt-16">
              <router-link
                to="/enroll"
                class="inline-block bg-blue-600 hover:bg-blue-700 text-white px-10 py-4 rounded-full font-semibold transition"
              >
                Enroll Your Child Today
              </router-link>
            </div>
          </div>
        </div>
      </section>

      <!-- FINAL CTA -->
      <section class="flex items-center justify-center">
        <div
          class="w-full bg-blue-200/70 backdrop-blur-lg p-14 md:p-20 shadow-xl text-center"
          data-aos="fade-up"
        >
          <div class="max-w-4xl mx-auto px-6">
            <h2 class="text-3xl md:text-4xl font-bold text-blue-700 mb-6">
              Give Your Child a Strong Foundation for Life
            </h2>

            <p class="text-gray-700 text-lg leading-relaxed mb-6">
              At Great Minds Christian Academy, we combine quality education,
              strong Christian values, and modern learning tools to help every
              child discover their purpose and reach their full potential.
            </p>

            <p class="text-gray-700 text-lg leading-relaxed mb-10">
              Join a community committed to nurturing confident, creative, and
              godly leaders prepared for tomorrow.
            </p>

            <!-- CTA Buttons -->
            <div class="flex flex-col sm:flex-row gap-4 justify-center">
              <router-link
                to="/enroll"
                class="inline-block bg-blue-600 hover:bg-blue-700 text-white px-10 py-4 rounded-full font-semibold transition"
              >
                Enroll Now
              </router-link>

              <router-link
                to="/contact"
                class="inline-block bg-white/80 hover:bg-white text-blue-700 px-10 py-4 rounded-full font-semibold transition"
              >
                Contact Us
              </router-link>
            </div>
          </div>
        </div>
      </section>
    </div>
  </div>
  <PageFooter />
</template>

<script setup>
import { ref, onMounted } from "vue";
import bgPattern from "@/assets/images/uniform-pattern.png";
import PageFooter from "@/components/PageFooter.vue";

const images = [
  "/src/assets/images/slide1.jpg",
  "/src/assets/images/slide2.jpg",
  "/src/assets/images/slide3.jpg",
];

const currentImage = ref(images[0]);
let index = 0;

onMounted(() => {
  setInterval(() => {
    index = (index + 1) % images.length;
    currentImage.value = images[index];
  }, 4000);
});
</script>

<style>
.fade-enter-active,
.fade-leave-active {
  transition: opacity 1.5s ease;
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}
</style>
