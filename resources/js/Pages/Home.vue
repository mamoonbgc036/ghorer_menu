<template>
  <CustomerLayout>
    <!-- Hero Section -->
    <div
      class="relative flex items-center justify-center min-h-[calc(100vh-4rem)] bg-gradient-to-b from-gray-50 to-white dark:from-gray-900 dark:to-gray-800 overflow-hidden">
      <!-- Background Pattern -->
      <div class="absolute inset-0 z-0">
        <div
          class="absolute inset-0 bg-gradient-to-br from-orange-500/10 to-purple-500/10 dark:from-orange-900/20 dark:to-purple-900/20">
        </div>
        <div class="absolute inset-0 bg-grid-pattern opacity-[0.07] dark:opacity-[0.03]"></div>
      </div>

      <!-- Floating Elements -->
      <div class="absolute inset-0 overflow-hidden pointer-events-none">
        <div v-for="(item, index) in floatingItems" :key="index" :class="item.class"
          class="absolute opacity-[0.15] dark:opacity-[0.08]">
          <i :class="item.icon + ' text-5xl md:text-7xl text-orange-600 dark:text-orange-400'"></i>
        </div>
      </div>

      <!-- Main Content -->
      <div class="relative z-10 w-full max-w-6xl mx-auto px-4 sm:px-6 lg:px-8 py-20 md:py-28">
        <div class="text-center space-y-8">
          <!-- Main Heading -->
          <h1 class="text-5xl sm:text-6xl md:text-7xl font-bold tracking-tight">
            <span
              class="block text-transparent bg-clip-text bg-gradient-to-r from-orange-600 to-red-600 dark:from-orange-500 dark:to-red-500 animate-gradient pb-2">
              Delicious Food
            </span>
            <span class="block text-gray-900 dark:text-white">
              Delivered To Your Door
            </span>
          </h1>

          <!-- Subheading -->
          <p class="max-w-2xl mx-auto text-xl md:text-2xl text-gray-600 dark:text-gray-300 leading-relaxed">
            Experience the finest restaurants in your area with our quick and reliable delivery service.
          </p>

          <!-- CTA Button -->
          <div class="pt-4">
            <Link :href="route('customer.locations')"
              class="group relative inline-flex items-center justify-center overflow-hidden rounded-full p-0.5 font-bold text-lg focus:outline-none focus:ring-4 focus:ring-orange-500/50 dark:focus:ring-orange-500/30">
            <span class="absolute h-full w-full bg-gradient-to-br from-orange-500 to-red-600"></span>
            <span
              class="relative flex items-center justify-center space-x-2 rounded-full bg-white dark:bg-gray-900 px-10 py-4 transition-all duration-300 ease-out group-hover:bg-opacity-0">
              <span class="text-orange-600 dark:text-orange-400 group-hover:text-white transition-colors">
                Order Now
              </span>
              <i
                class="fas fa-arrow-right text-orange-600 dark:text-orange-400 group-hover:text-white transition-colors"></i>
            </span>
            </Link>
          </div>

          <!-- Features -->
          <div class="grid grid-cols-1 sm:grid-cols-3 gap-6 lg:gap-8 pt-20">
            <div v-for="(feature, index) in features" :key="index" class="relative" :data-aos="feature.aos"
              :data-aos-delay="feature.delay">
              <div
                class="group h-full flex flex-col items-center p-8 bg-white dark:bg-gray-800/50 backdrop-blur-sm rounded-2xl shadow-lg hover:shadow-xl dark:shadow-gray-900/10 transition-all duration-300 hover:-translate-y-1">
                <div
                  class="flex h-16 w-16 items-center justify-center rounded-full bg-gradient-to-br from-orange-500/10 to-red-500/10 dark:from-orange-500/20 dark:to-red-500/20 group-hover:from-orange-500/20 group-hover:to-red-500/20 transition-all duration-300">
                  <i :class="feature.icon + ' text-3xl text-orange-600 dark:text-orange-400'"></i>
                </div>
                <h3 class="mt-6 text-xl font-semibold text-gray-900 dark:text-white">
                  {{ feature.title }}
                </h3>
                <p class="mt-4 text-base text-gray-600 dark:text-gray-400 leading-relaxed">
                  {{ feature.description }}
                </p>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- How It Works Section -->
    <section class="py-20 bg-gray-50 dark:bg-gray-900">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="text-center mb-16">
          <h2 class="text-3xl font-bold text-gray-900 dark:text-white sm:text-4xl">
            How It Works
          </h2>
          <p class="mt-4 text-lg text-gray-600 dark:text-gray-400">
            Get your favorite food in 3 simple steps
          </p>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
          <div v-for="step in steps" :key="step.id" class="relative" data-aos="fade-up" :data-aos-delay="step.delay">
            <div class="flex flex-col items-center text-center">
              <div
                class="w-16 h-16 rounded-full bg-orange-100 dark:bg-orange-900/50 flex items-center justify-center mb-6">
                <i :class="step.icon + ' text-2xl text-orange-600 dark:text-orange-400'"></i>
              </div>
              <h3 class="text-xl font-semibold text-gray-900 dark:text-white mb-4">
                {{ step.title }}
              </h3>
              <p class="text-gray-600 dark:text-gray-400">
                {{ step.description }}
              </p>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- Popular Categories -->
    <section class="py-20 bg-white dark:bg-gray-800">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="text-center mb-16">
          <h2 class="text-3xl font-bold text-gray-900 dark:text-white sm:text-4xl">
            Popular Categories
          </h2>
          <p class="mt-4 text-lg text-gray-600 dark:text-gray-400">
            Explore our wide variety of cuisines
          </p>
        </div>

        <div class="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-6 gap-6">
          <div v-for="category in categories" :key="category.id" class="group relative" data-aos="fade-up"
            :data-aos-delay="category.delay">
            <div
              class="flex flex-col items-center p-4 rounded-xl bg-gray-50 dark:bg-gray-700 hover:bg-orange-50 dark:hover:bg-orange-900/20 transition-all duration-300 cursor-pointer">
              <div
                class="w-20 h-20 rounded-full bg-white dark:bg-gray-800 p-4 mb-4 group-hover:scale-110 transition-transform duration-300">
                <img :src="category.image" :alt="category.name" class="w-full h-full object-contain" />
              </div>
              <h3 class="text-sm font-medium text-gray-900 dark:text-white text-center">
                {{ category.name }}
              </h3>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- App Download Section -->
    <section class="py-20 bg-gradient-to-br from-orange-500 to-red-600 dark:from-orange-900 dark:to-red-900">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="grid grid-cols-1 md:grid-cols-2 gap-12 items-center">
          <div class="text-white">
            <h2 class="text-3xl sm:text-4xl font-bold mb-6">
              Download Our Mobile App
            </h2>
            <p class="text-lg text-white/90 mb-8">
              Get the best food delivery experience with our mobile app. Order food, track delivery, and get exclusive
              offers.
            </p>
            <div class="flex flex-wrap gap-4">
              <button
                class="flex items-center px-6 py-3 bg-black rounded-lg hover:bg-gray-900 transition-colors duration-300">
                <i class="fab fa-apple text-2xl mr-3"></i>
                <div class="text-left">
                  <div class="text-xs">Download on the</div>
                  <div class="text-sm font-semibold">App Store</div>
                </div>
              </button>
              <button
                class="flex items-center px-6 py-3 bg-black rounded-lg hover:bg-gray-900 transition-colors duration-300">
                <i class="fab fa-google-play text-2xl mr-3"></i>
                <div class="text-left">
                  <div class="text-xs">Get it on</div>
                  <div class="text-sm font-semibold">Google Play</div>
                </div>
              </button>
            </div>
          </div>
          <div class="relative" data-aos="fade-left">
            <img src="/mockup-app.png" alt="Mobile App" class="w-full max-w-sm mx-auto" />
          </div>
        </div>
      </div>
    </section>

    <!-- Newsletter Section -->
    <section class="py-20 bg-white dark:bg-gray-800">
      <div class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
        <h2 class="text-3xl font-bold text-gray-900 dark:text-white sm:text-4xl mb-4">
          Stay Updated
        </h2>
        <p class="text-lg text-gray-600 dark:text-gray-400 mb-8">
          Subscribe to our newsletter for exclusive offers and updates
        </p>
        <form @submit.prevent="subscribeNewsletter" class="max-w-md mx-auto flex gap-4">
          <input type="email" v-model="newsletterEmail" placeholder="Enter your email"
            class="flex-1 px-4 py-3 rounded-lg border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-700 text-gray-900 dark:text-white focus:ring-2 focus:ring-orange-500"
            required />
          <button type="submit"
            class="px-6 py-3 bg-orange-600 text-white rounded-lg hover:bg-orange-700 transition-colors duration-300">
            Subscribe
          </button>
        </form>
      </div>
    </section>
  </CustomerLayout>
</template>

<script setup>
import { ref } from 'vue';
import { Link } from '@inertiajs/vue3';
import CustomerLayout from '@/Layouts/CustomerLayout.vue';
import { onMounted } from 'vue';
import AOS from 'aos';
import 'aos/dist/aos.css';

// State
const newsletterEmail = ref('');

// Floating items configuration
const floatingItems = [
  { icon: 'fas fa-pizza-slice', class: 'top-1/4 left-1/4 animate-float-slow' },
  { icon: 'fas fa-hamburger', class: 'top-1/3 right-1/4 animate-float-slower' },
  { icon: 'fas fa-ice-cream', class: 'bottom-1/4 left-1/3 animate-float' },
  { icon: 'fas fa-coffee', class: 'top-1/2 right-1/3 animate-float-slow' },
  { icon: 'fas fa-utensils', class: 'bottom-1/3 right-1/4 animate-float-slower' },
];

// Features section
const features = [
  {
    icon: 'fas fa-shipping-fast',
    title: 'Lightning Fast Delivery',
    description: 'From kitchen to your doorstep in 30 minutes or less, ensuring your food arrives hot and fresh.',
    aos: 'fade-up',
    delay: '0',
  },
  {
    icon: 'fas fa-utensils',
    title: 'Premium Quality',
    description: 'Carefully selected restaurants and quality checks ensure you get the best dining experience.',
    aos: 'fade-up',
    delay: '100',
  },
  {
    icon: 'fas fa-shield-alt',
    title: 'Safe & Secure',
    description: 'Contactless delivery options and secure payment methods for your peace of mind.',
    aos: 'fade-up',
    delay: '200',
  },
];

// How it works steps
const steps = [
  {
    id: 1,
    icon: 'fas fa-map-marker-alt',
    title: 'Choose Location',
    description: 'Enter your address to find nearby restaurants',
    delay: 0,
  },
  {
    id: 2,
    icon: 'fas fa-utensils',
    title: 'Select Food',
    description: 'Browse menus and select your favorite dishes',
    delay: 100,
  },
  {
    id: 3,
    icon: 'fas fa-truck',
    title: 'Get Delivery',
    description: 'Enjoy your meal delivered right to your door',
    delay: 200,
  },
];

// Popular categories
const categories = [
  {
    id: 1,
    name: 'Pizza',
    image: '/icons/pizza.svg',
    delay: 0,
  },
  {
    id: 2,
    name: 'Burgers',
    image: '/icons/burger.svg',
    delay: 50,
  },
  {
    id: 3,
    name: 'Sushi',
    image: '/icons/sushi.svg',
    delay: 100,
  },
  {
    id: 4,
    name: 'Italian',
    image: '/icons/pasta.svg',
  },



  {
    id: 5,
    name: 'Chinese',
    image: '/icons/chinese.svg',
    delay: 150,
  },
  {
    id: 6,
    name: 'Indian',
    image: '/icons/indian.svg',
    delay: 200,
  }
];

// Methods
const subscribeNewsletter = () => {
  // Handle newsletter subscription
  console.log('Newsletter subscription:', newsletterEmail.value);
  // Add your newsletter subscription logic here
  newsletterEmail.value = '';
  // Show success message
  alert('Thanks for subscribing!');
};

onMounted(() => {
  // Initialize AOS
  AOS.init({
    duration: 1000,
    once: true,
    offset: 50,
    delay: 50,
    easing: 'ease-in-out',
  });
});
</script>

<style scoped>
/* Background Grid Pattern */
.bg-grid-pattern {
  background-image: radial-gradient(circle, #ea580c 0.5px, transparent 0.5px);
  background-size: 24px 24px;
}

/* Enhanced Floating Animations */
@keyframes float {

  0%,
  100% {
    transform: translateY(0) rotate(0deg);
    opacity: 0.15;
  }

  50% {
    transform: translateY(-20px) rotate(2deg);
    opacity: 0.2;
  }
}

@keyframes float-slow {

  0%,
  100% {
    transform: translateY(0) rotate(0deg);
    opacity: 0.15;
  }

  50% {
    transform: translateY(-30px) rotate(-2deg);
    opacity: 0.2;
  }
}

@keyframes float-slower {

  0%,
  100% {
    transform: translateY(0) rotate(0deg);
    opacity: 0.15;
  }

  50% {
    transform: translateY(-40px) rotate(3deg);
    opacity: 0.2;
  }
}

.animate-float {
  animation: float 4s cubic-bezier(0.4, 0, 0.2, 1) infinite;
}

.animate-float-slow {
  animation: float-slow 6s cubic-bezier(0.4, 0, 0.2, 1) infinite;
}

.animate-float-slower {
  animation: float-slower 8s cubic-bezier(0.4, 0, 0.2, 1) infinite;
}

/* Enhanced Gradient Animation */
@keyframes gradient {
  0% {
    background-position: 0% 50%;
  }

  50% {
    background-position: 100% 50%;
  }

  100% {
    background-position: 0% 50%;
  }
}

.animate-gradient {
  background-size: 200% auto;
  animation: gradient 6s linear infinite;
}

/* Card Hover Effects */
.feature-card {
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.feature-card:hover {
  transform: translateY(-4px);
}

/* Category Card Hover Effects */
.category-card {
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.category-card:hover {
  transform: scale(1.05);
}

/* Button Hover Effects */
.btn-hover-effect {
  position: relative;
  overflow: hidden;
}

.btn-hover-effect::after {
  content: '';
  position: absolute;
  top: 50%;
  left: 50%;
  width: 120%;
  height: 120%;
  background: radial-gradient(circle, rgba(255, 255, 255, 0.2) 0%, transparent 70%);
  transform: translate(-50%, -50%) scale(0);
  transition: transform 0.5s;
}

.btn-hover-effect:hover::after {
  transform: translate(-50%, -50%) scale(1);
}

/* Smooth Scrolling */
html {
  scroll-behavior: smooth;
}

/* Custom Scrollbar */
::-webkit-scrollbar {
  width: 8px;
}

::-webkit-scrollbar-track {
  background: transparent;
}

::-webkit-scrollbar-thumb {
  background: #ea580c;
  border-radius: 4px;
}

::-webkit-scrollbar-thumb:hover {
  background: #c2410c;
}

/* Dark Mode Scrollbar */
.dark ::-webkit-scrollbar-thumb {
  background: #f97316;
}

.dark ::-webkit-scrollbar-thumb:hover {
  background: #ea580c;
}

/* Image Loading States */
.image-loading {
  position: relative;
  overflow: hidden;
}

.image-loading::before {
  content: '';
  position: absolute;
  inset: 0;
  background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.1), transparent);
  animation: shimmer 1.5s infinite;
}

@keyframes shimmer {
  0% {
    transform: translateX(-100%);
  }

  100% {
    transform: translateX(100%);
  }
}

/* Section Transitions */
.section-fade-up {
  opacity: 0;
  transform: translateY(20px);
  transition: all 0.6s cubic-bezier(0.4, 0, 0.2, 1);
}

.section-fade-up.visible {
  opacity: 1;
  transform: translateY(0);
}

/* Responsive Adjustments */
@media (max-width: 640px) {
  .hero-content {
    padding-top: 2rem;
    padding-bottom: 2rem;
  }

  .floating-items {
    display: none;
  }
}

@media (max-width: 768px) {
  .category-grid {
    grid-template-columns: repeat(3, 1fr);
  }
}

@media (min-width: 1024px) {
  .hero-content {
    padding-top: 4rem;
    padding-bottom: 4rem;
  }
}
</style>
