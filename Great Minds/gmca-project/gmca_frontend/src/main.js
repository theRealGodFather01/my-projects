import { createApp } from "vue";
import "./style.css";
import App from "./App.vue";
import router from "./router";
import AOS from "aos";
import "aos/dist/aos.css";

const app = createApp(App);

app.use(router);
app.mount("#app");

AOS.init({
    duration: 800,
    easing: "ease-in-out",
    once: false,     // re-animate every time
    mirror: true,   // animate when scrolling UP
  });