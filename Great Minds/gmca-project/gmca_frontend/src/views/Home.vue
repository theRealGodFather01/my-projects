<template>
  <div>
    <HeroSection />
    <About />
    <Classes :classes="classes" />
    <WhyChooseUs :reasons="reasons" />
    <PageFooter />
  </div>
</template>

<script setup>
import HeroSection from "@/components/HeroSection.vue"
import About from "@/components/About.vue"
import Classes from "@/components/Classes.vue"
import WhyChooseUs from "@/components/WhyChooseUs.vue"
import PageFooter from "@/components/PageFooter.vue"

const classes = [
  {
    title: "Kindergarten Class",
    description: "Building faith and character in the next generation.",
    image: new URL("@/assets/images/grade_1.jpg", import.meta.url).href,
  },
  {
    title: "Grade 1 Class",
    description: "Strengthen your spiritual foundation and grow deeper.",
    image: new URL("@/assets/images/grade_1.jpg", import.meta.url).href,
  },
  {
    title: "Grade 2 Class",
    description: "Raising godly children through fun learning.",
    image: new URL("@/assets/images/grade_1.jpg", import.meta.url).href,
  },
  {
    title: "Grade 3 Class",
    description: "Raising godly children through fun learning.",
    image: new URL("@/assets/images/grade_1.jpg", import.meta.url).href,
  },
  {
    title: "Grade 4 Class",
    description: "Raising godly children through fun learning.",
    image: new URL("@/assets/images/grade_1.jpg", import.meta.url).href,
  },
  {
    title: "Grade 5 Class",
    description: "Raising godly children through fun learning.",
    image: new URL("@/assets/images/grade_1.jpg", import.meta.url).href,
  },
]

const reasons = [
  "Strong community culture",
  "Dedicated mentors and teachers",
  "Practical and spiritual development",
]
</script>
