<template>
  <CustomerLayout>
    <!-- Hero Section -->
    <div
      class="relative flex items-center justify-center bg-gradient-to-b from-gray-50 to-white dark:from-gray-900 dark:to-gray-800 overflow-visible"
    >
      <!-- Background Pattern -->
      <div class="absolute inset-0 z-0">
        <div
          class="absolute inset-0 bg-gradient-to-br from-orange-500/10 to-purple-500/10 dark:from-orange-900/20 dark:to-purple-900/20"
        ></div>
        <div class="absolute inset-0 bg-grid-pattern opacity-[0.07] dark:opacity-[0.03]"></div>
      </div>

      <!-- Floating Elements -->
      <div class="absolute inset-0 overflow-hidden pointer-events-none">
        <div
          v-for="(item, index) in floatingItems"
          :key="index"
          :class="item.class"
          class="absolute opacity-[0.15] dark:opacity-[0.08]"
        >
          <i :class="item.icon + ' text-5xl md:text-7xl text-orange-600 dark:text-orange-400'"></i>
        </div>
      </div>

      <!-- Main Content -->
      <div class="relative z-10 w-full max-w-6xl mx-auto m-0 p-5">
        <div class="text-center space-y-8">
          <!-- Main Heading -->
          <h1 class="text-5xl sm:text-6xl md:text-7xl font-bold tracking-tight">
            <span
              class="block text-transparent bg-clip-text bg-gradient-to-r from-orange-600 to-red-600 dark:from-orange-500 dark:to-red-500 animate-gradient pb-2"
            >Select Your Favourit Food</span>
          </h1>

          <!-- Subheading -->
          <p
            class="max-w-2xl mx-auto text-xl md:text-2xl text-gray-600 dark:text-gray-300 leading-relaxed"
          >Within Our Best Restaurants And Catering Servics</p>

          <!-- CTA Button -->
          <!-- Search Field -->
          <div class="relative max-w-xl mx-auto">
            <input
              type="text"
              v-model="searchQuery"
              @input="check"
              placeholder="type your local area"
              class="text-center w-full rounded-full border-2 border-orange-500 dark:border-orange-400 px-6 py-4 text-lg text-gray-900 dark:text-white bg-white dark:bg-gray-900 focus:outline-none focus:ring-4 focus:ring-orange-500/50 dark:focus:ring-orange-400/30 transition duration-300"
            />
            <ul
              v-if="searchQuery.length > 0 && showDropDown"
              class="mt-2 absolute w-full text-center bg-white dark:bg-gray-800 border border-gray-300 dark:border-gray-700 rounded-lg shadow-md z-50"
            >
              <li
                v-for="(local, index) in filterLocal"
                :key="index"
                @click="selectedArea(local)"
                class="text-gray-700 cursor-pointer dark:text-gray-300 px-4 py-2 hover:bg-gray-100 dark:hover:bg-gray-700 rounded z-50"
              >{{ local.name }}</li>
            </ul>
          </div>
        </div>
      </div>
    </div>
    <TransitionGroup name="list" tag="div" class="grid gap-6 sm:grid-cols-2 lg:grid-cols-3 mt-3">
      <div
        v-for="branch in filteredBranches"
        :key="branch.id"
        class="bg-white dark:bg-gray-800 rounded-lg shadow-sm hover:shadow-md transition-all duration-300 border border-gray-200 dark:border-gray-700"
        data-aos="fade-up"
      >
        <!-- Status Badge -->
        <div class="p-4 border-b border-gray-200 dark:border-gray-700">
          <div class="flex justify-between items-start">
            <h3 class="text-lg font-semibold text-gray-900 dark:text-gray-100">{{ branch.name }}</h3>
            <span
              :class="[
                                    'inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium',
                                    isOpen(branch.opening_hours)
                                        ? 'bg-green-100 text-green-800 dark:bg-green-900/50 dark:text-green-300'
                                        : 'bg-red-100 text-red-800 dark:bg-red-900/50 dark:text-red-300',
                                ]"
            >
              {{
              isOpen(branch.opening_hours)
              ? "Open Now"
              : "Closed"
              }}
            </span>
          </div>

          <address
            class="mt-2 text-sm text-gray-500 dark:text-gray-400 not-italic"
          >{{ branch.address }}</address>
        </div>

        <!-- Branch Details -->
        <div class="p-4 space-y-4">
          <!-- Distance & Delivery Info -->
          <div class="flex items-center justify-between text-sm">
            <span class="inline-flex items-center text-gray-500 dark:text-gray-400">
              <i class="fas fa-map-marker-alt text-indigo-500 mr-2"></i>
              {{ formatDistance(branch.distance) }}
            </span>
            <span class="inline-flex items-center text-gray-500 dark:text-gray-400">
              <i class="fas fa-truck text-indigo-500 mr-2"></i>
              Up to {{ branch.delivery_radius }}km
            </span>
          </div>

          <!-- Contact -->
          <div class="text-sm text-gray-500 dark:text-gray-400">
            <i class="fas fa-phone text-indigo-500 mr-2"></i>
            {{ branch.contact_number }}
          </div>
          <!-- Opening Hours -->
          <div class="space-y-2">
            <h4 class="text-sm font-medium text-gray-700 dark:text-gray-300">Opening Hours</h4>
            <div class="max-h-64 overflow-y-auto scrollbar-thin">
              <table class="w-full text-sm text-left">
                <thead
                  class="text-gray-700 dark:text-gray-300 border-b border-gray-300 dark:border-gray-600"
                >
                  <tr>
                    <th class="py-2 px-4 text-left">
                      <i class="fas fa-calendar-day mr-1 text-blue-500"></i>
                      Day
                    </th>
                    <th class="py-2 px-4 text-center">
                      <i class="fas fa-coffee mr-1 text-yellow-500"></i>
                      Breakfast
                    </th>
                    <th class="py-2 px-4 text-center">
                      <i class="fas fa-utensils mr-1 text-blue-600"></i>
                      Lunch
                    </th>
                    <th class="py-2 px-4 text-center">
                      <i class="fas fa-moon mr-1 text-purple-500"></i>
                      Dinner
                    </th>
                  </tr>
                </thead>
                <tbody>
                  <tr
                    v-for="hours in branch.opening_hours"
                    :key="hours.day"
                    class="text-gray-500 dark:text-gray-400"
                  >
                    <td class="py-2 pr-4">{{ hours.day }}</td>
                    <td class="py-2">
                      {{
                      formatTime(
                      hours.breakfast.start
                      )
                      }}
                      -
                      {{
                      formatTime(
                      hours.breakfast.end
                      )
                      }}
                    </td>
                    <td class="py-2">
                      {{ formatTime(hours.lunch.start) }}
                      -
                      {{
                      formatTime(hours.lunch.end)
                      }}
                    </td>
                    <td class="py-2">
                      {{
                      formatTime(
                      hours.dinner.start
                      )
                      }}
                      -
                      {{
                      formatTime(hours.dinner.end)
                      }}
                    </td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>

          <!-- Action Buttons -->
          <div class="flex flex-wrap gap-3 pt-4 border-t border-gray-200 dark:border-gray-700">
            <Link
              :href="
                                    route('customer.branch.menu', {
                                        branch: branch.id,
                                        type: 'collection',
                                    })
                                "
              class="flex-1 inline-flex items-center justify-center px-4 py-2 border border-indigo-600 text-sm font-medium rounded-md text-indigo-600 bg-white hover:bg-indigo-50 focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 dark:focus:ring-offset-gray-800"
            >
              <i class="fas fa-shopping-bag mr-2"></i>
              Order Now
            </Link>

            <a
              :href="getDirectionsUrl(branch)"
              target="_blank"
              rel="noopener noreferrer"
              class="inline-flex items-center px-4 py-2 border border-gray-300 text-sm font-medium rounded-md text-gray-700 dark:text-gray-300 bg-white dark:bg-gray-800 hover:bg-gray-50 dark:hover:bg-gray-700 focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 dark:focus:ring-offset-gray-800"
            >
              <i class="fas fa-directions mr-2"></i>
              Directions
            </a>
          </div>
        </div>
      </div>
    </TransitionGroup>
  </CustomerLayout>
</template>

<script>
import CustomerLayout from "@/Layouts/CustomerLayout.vue";
import { Link } from "@inertiajs/vue3";
import AOS from "aos";
import "aos/dist/aos.css";
import "aos/dist/aos.css";
import dayjs from "dayjs";
import utc from "dayjs/plugin/utc";
import timezone from "dayjs/plugin/timezone";

dayjs.extend(utc);
dayjs.extend(timezone);

export default {
  name: "Home",
  components: {
    CustomerLayout,
    Link,
  },
  props: {
    branches: {
      type: Array,
      required: true,
    },
    locals: {
      type: Array,
      required: true,
    },
  },
  mounted() {
    AOS.init({
      duration: 1000,
      once: true,
      offset: 50,
      delay: 50,
      easing: "ease-in-out",
    });
    this.filterLocal = this.locals;
    this.filteredBranches = this.branches;
  },
  data() {
    return {
      searchQuery: "",
      showDropDown: false,
      filteredBranches: [],
      filterLocal: [],
      floatingItems: [
        {
          icon: "fas fa-pizza-slice",
          class: "top-1/4 left-1/4 animate-float-slow",
        },
        {
          icon: "fas fa-hamburger",
          class: "top-1/3 right-1/4 animate-float-slower",
        },
        {
          icon: "fas fa-ice-cream",
          class: "bottom-1/4 left-1/3 animate-float",
        },
        {
          icon: "fas fa-coffee",
          class: "top-1/2 right-1/3 animate-float-slow",
        },
        {
          icon: "fas fa-utensils",
          class: "bottom-1/3 right-1/4 animate-float-slower",
        },
      ],
    };
  },
  methods: {
    check() {
      this.showDropDown = true;
      this.filteredBranches = this.branches;
      const query = this.searchQuery.toLowerCase();
      this.filterLocal = this.locals.filter((local) =>
        local.name.toLowerCase().includes(query)
      );
    },
    getDirectionsUrl(branch) {
      const destination = `${branch.latitude},${branch.longitude}`;
      return `https://www.google.com/maps/dir/?api=1&destination=${destination}`;
    },
    isOpen(hours) {
      if (!hours) return false;
      const now = new Date();
      const day = now.toLocaleDateString("en-US", { weekday: "long" });
      const time = now.toLocaleTimeString("en-US", { hour12: false });
      const todayHours = hours.find((h) => h.day === day);
      return todayHours
        ? time >= todayHours.open && time <= todayHours.close
        : false;
    },
    formatDistance(distance) {
      if (!distance) return "Distance unknown";
      return `${distance.toFixed(1)} km away`;
    },
    formatTime(time) {
      return dayjs(`1970-01-01 ${time}`).tz("Asia/Dhaka").format("hh:mm A");
    },
    selectedArea(value) {
      this.searchQuery = value.name;
      this.showDropDown = false;
      console.log(value.division_id);
      if (value.division_id <= 0) {
        console.log(value);
        this.filteredBranches = this.branches.filter(
          (branch) => branch.local_id === value.own_id
        );
      } else {
        this.filteredBranches = this.branches.filter(
          (branch) => branch.thana_id === value.id
        );
      }
    },
  },
};
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
  content: "";
  position: absolute;
  top: 50%;
  left: 50%;
  width: 120%;
  height: 120%;
  background: radial-gradient(
    circle,
    rgba(255, 255, 255, 0.2) 0%,
    transparent 70%
  );
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
  content: "";
  position: absolute;
  inset: 0;
  background: linear-gradient(
    90deg,
    transparent,
    rgba(255, 255, 255, 0.1),
    transparent
  );
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
