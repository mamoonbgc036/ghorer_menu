<template>
  <CustomerLayout>
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
      <!-- Header Section -->
      <div class="flex flex-col md:flex-row md:items-center md:justify-between mb-8">
        <div>
          <p
            class="mt-2 text-gray-600 dark:text-gray-400"
          >Find the nearest branch and place your order</p>
        </div>

        <!-- View Options -->
        <div class="mt-4 md:mt-0 flex items-center space-x-4">
          <div class="flex items-center space-x-2">
            <select
              v-model="sortOrder"
              class="form-select rounded-md border-gray-300 dark:border-gray-700 bg-white dark:bg-gray-800 text-gray-700 dark:text-gray-300 text-sm focus:ring-indigo-500 focus:border-indigo-500"
            >
              <option value="distance">Sort by Distance</option>
              <option value="name">Sort by Name</option>
            </select>
          </div>
        </div>
      </div>

      <!-- Search Section -->
      <div class="mb-8 bg-white dark:bg-gray-800 rounded-lg shadow-sm p-4">
        <div class="max-w-3xl mx-auto">
          <div class="relative">
            <input
              type="text"
              v-model="searchQuery"
              @input="check"
              placeholder="Type Your Place"
              class="w-full py-3 px-4 text-center rounded-lg border border-gray-300 dark:border-gray-700 bg-gray-50 dark:bg-gray-800 text-gray-700 dark:text-gray-300 focus:ring-2 focus:ring-indigo-500"
            />
            <ul
              v-if="searchQuery.length > 0 && showDropDown"
              class="mt-2 absolute w-full text-center bg-white dark:bg-gray-800 border border-gray-300 dark:border-gray-700 rounded-lg shadow-md z-10"
            >
              <li
                v-for="(local, index) in filterLocal"
                :key="index"
                @click="selectedArea(local)"
                class="text-gray-700 cursor-pointer dark:text-gray-300 px-4 py-2 hover:bg-gray-100 dark:hover:bg-gray-700 rounded"
              >{{ local.name }}</li>
            </ul>
          </div>
          <div class="mt-4 flex flex-wrap gap-4">
            <label class="inline-flex items-center">
              <input
                type="checkbox"
                v-model="showOpenOnly"
                class="form-checkbox h-4 w-4 text-indigo-600 rounded border-gray-300"
              />
              <span class="ml-2 text-gray-700 dark:text-gray-300">Open Now</span>
            </label>
            <label class="inline-flex items-center">
              <input
                type="checkbox"
                v-model="deliveryOnly"
                class="form-checkbox h-4 w-4 text-indigo-600 rounded border-gray-300"
              />
              <span class="ml-2 text-gray-700 dark:text-gray-300">Delivery Available</span>
            </label>
          </div>
        </div>
      </div>

      <!-- Branches Grid -->
      <TransitionGroup name="list" tag="div" class="grid gap-6 sm:grid-cols-2 lg:grid-cols-3">
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

      <!-- No Results -->
      <div
        v-if="branches.length === 0"
        class="text-center py-12 bg-white dark:bg-gray-800 rounded-lg shadow-sm"
      >
        <i class="fas fa-store-slash text-4xl text-gray-400 mb-4"></i>
        <h3 class="text-lg font-medium text-gray-900 dark:text-gray-100">No branches found</h3>
        <p class="mt-2 text-gray-500 dark:text-gray-400">Try adjusting your search criteria</p>
      </div>
    </div>
  </CustomerLayout>
</template>

<script>
import { debounce } from "lodash/debounce";
import { Link } from "@inertiajs/vue3";
import CustomerLayout from "@/Layouts/CustomerLayout.vue";
import AOS from "aos";
import "aos/dist/aos.css";
import dayjs from "dayjs";
import utc from "dayjs/plugin/utc";
import timezone from "dayjs/plugin/timezone";

dayjs.extend(utc);
dayjs.extend(timezone);

export default {
  name: "BranchLocator",

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

  data() {
    return {
      searchQuery: "",
      showDropDown: false,
      showOpenOnly: false,
      deliveryOnly: false,
      filteredBranches: [],
      filterLocal: [],
      sortOrder: "distance",
    };
  },
  mounted() {
    // Initialize AOS
    AOS.init({ duration: 700 });
    this.filterLocal = this.locals;
    this.filteredBranches = this.branches;
  },

  methods: {
    formatTime(time) {
      return dayjs(`1970-01-01 ${time}`).tz("Asia/Dhaka").format("hh:mm A");
    },
    check() {
      this.showDropDown = true;
      this.filteredBranches = this.branches;
      const query = this.searchQuery.toLowerCase();
      this.filterLocal = this.locals.filter((local) =>
        local.name.toLowerCase().includes(query)
      );
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

    isDeliveryAvailable(branch) {
      if (!branch.distance || !branch.delivery_radius) return true;
      return branch.distance <= branch.delivery_radius;
    },

    formatDistance(distance) {
      if (!distance) return "Distance unknown";
      return `${distance.toFixed(1)} km away`;
    },

    getDirectionsUrl(branch) {
      const destination = `${branch.latitude},${branch.longitude}`;
      return `https://www.google.com/maps/dir/?api=1&destination=${destination}`;
    },
  },
};
</script>

<style scoped>
.list-enter-active,
.list-leave-active {
  transition: all 0.5s ease;
}
.list-enter-from,
.list-leave-to {
  opacity: 0;
  transform: translateY(30px);
}

/* Scrollbar styling */
.scrollbar-thin {
  scrollbar-width: thin;
  scrollbar-color: rgba(156, 163, 175, 0.5) transparent;
}
.scrollbar-thin::-webkit-scrollbar {
  width: 6px;
}
.scrollbar-thin::-webkit-scrollbar-track {
  background: transparent;
}
.scrollbar-thin::-webkit-scrollbar-thumb {
  background-color: rgba(156, 163, 175, 0.5);
  border-radius: 3px;
}
</style>