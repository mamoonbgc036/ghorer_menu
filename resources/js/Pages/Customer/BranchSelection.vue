<template>
    <CustomerLayout>
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <!-- Header Section -->
        <div class="flex flex-col md:flex-row md:items-center md:justify-between mb-8">
          <div>
            <h2 class="text-3xl font-bold text-gray-900 dark:text-gray-100">
              Available Branches
              <span class="text-lg font-normal text-gray-600 dark:text-gray-400">
                ({{ filteredBranches.length }} locations)
              </span>
            </h2>
            <p class="mt-2 text-gray-600 dark:text-gray-400">
              Find the nearest branch and place your order
            </p>
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
                placeholder="Search by branch name or address..."
                class="w-full py-3 px-4 pl-11 rounded-lg border border-gray-300 dark:border-gray-700 bg-gray-50 dark:bg-gray-800 text-gray-700 dark:text-gray-300 focus:ring-2 focus:ring-indigo-500"
              />
              <i class="fas fa-search absolute left-4 top-1/2 -translate-y-1/2 text-gray-400"></i>
            </div>

            <div class="mt-4 flex flex-wrap gap-4">
              <label class="inline-flex items-center">
                <input
                  type="checkbox"
                  v-model="showOpenOnly"
                  class="form-checkbox h-4 w-4 text-indigo-600 rounded border-gray-300"
                >
                <span class="ml-2 text-gray-700 dark:text-gray-300">Open Now</span>
              </label>
              <label class="inline-flex items-center">
                <input
                  type="checkbox"
                  v-model="deliveryOnly"
                  class="form-checkbox h-4 w-4 text-indigo-600 rounded border-gray-300"
                >
                <span class="ml-2 text-gray-700 dark:text-gray-300">Delivery Available</span>
              </label>
            </div>
          </div>
        </div>

        <!-- Branches Grid -->
        <TransitionGroup
          name="list"
          tag="div"
          class="grid gap-6 sm:grid-cols-2 lg:grid-cols-3"
        >
          <div
            v-for="branch in filteredBranches"
            :key="branch.id"
            class="bg-white dark:bg-gray-800 rounded-lg shadow-sm hover:shadow-md transition-all duration-300 border border-gray-200 dark:border-gray-700"
            data-aos="fade-up"
          >
            <!-- Status Badge -->
            <div class="p-4 border-b border-gray-200 dark:border-gray-700">
              <div class="flex justify-between items-start">
                <h3 class="text-lg font-semibold text-gray-900 dark:text-gray-100">
                  {{ branch.name }}
                </h3>
                <span :class="[
                  'inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium',
                  isOpen(branch.opening_hours)
                    ? 'bg-green-100 text-green-800 dark:bg-green-900/50 dark:text-green-300'
                    : 'bg-red-100 text-red-800 dark:bg-red-900/50 dark:text-red-300'
                ]">
                  {{ isOpen(branch.opening_hours) ? 'Open Now' : 'Closed' }}
                </span>
              </div>

              <address class="mt-2 text-sm text-gray-500 dark:text-gray-400 not-italic">
                {{ branch.address }}
              </address>
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
                <div class="max-h-32 overflow-y-auto scrollbar-thin">
                  <table class="w-full text-sm">
                    <tbody>
                      <tr v-for="hours in branch.opening_hours" :key="hours.day" class="text-gray-500 dark:text-gray-400">
                        <td class="py-1 pr-4">{{ hours.day }}</td>
                        <td class="py-1">{{ hours.open }} - {{ hours.close }}</td>
                      </tr>
                    </tbody>
                  </table>
                </div>
              </div>

              <!-- Action Buttons -->
              <div class="flex flex-wrap gap-3 pt-4 border-t border-gray-200 dark:border-gray-700">
                <Link
                  v-if="isDeliveryAvailable(branch)"
                  :href="route('customer.branch.menu', { branch: branch.id, type: 'delivery' })"
                  class="flex-1 inline-flex items-center justify-center px-4 py-2 border border-transparent text-sm font-medium rounded-md text-white bg-indigo-600 hover:bg-indigo-700 focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 dark:focus:ring-offset-gray-800"
                >
                  <i class="fas fa-motorcycle mr-2"></i>
                  Order Delivery
                </Link>

                <Link
                  :href="route('customer.branch.menu', { branch: branch.id, type: 'collection' })"
                  class="flex-1 inline-flex items-center justify-center px-4 py-2 border border-indigo-600 text-sm font-medium rounded-md text-indigo-600 bg-white hover:bg-indigo-50 focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 dark:focus:ring-offset-gray-800"
                >
                  <i class="fas fa-shopping-bag mr-2"></i>
                  Order Collection
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
          v-if="filteredBranches.length === 0"
          class="text-center py-12 bg-white dark:bg-gray-800 rounded-lg shadow-sm"
        >
          <i class="fas fa-store-slash text-4xl text-gray-400 mb-4"></i>
          <h3 class="text-lg font-medium text-gray-900 dark:text-gray-100">No branches found</h3>
          <p class="mt-2 text-gray-500 dark:text-gray-400">
            Try adjusting your search criteria
          </p>
        </div>
      </div>
    </CustomerLayout>
  </template>

  <script setup>
  import { ref, computed } from 'vue'
  import { Link } from '@inertiajs/vue3'
  import CustomerLayout from '@/Layouts/CustomerLayout.vue'
  import AOS from 'aos'
  import 'aos/dist/aos.css'

  // Props using your existing data structure
  const props = defineProps({
    branches: {
      type: Array,
      required: true
    }
  })

  // State
  const searchQuery = ref('')
  const showOpenOnly = ref(false)
  const deliveryOnly = ref(false)
  const sortOrder = ref('distance')

  // Initialize AOS
  AOS.init({ duration: 700 })

  // Computed: Filtered and sorted branches
  const filteredBranches = computed(() => {
    let filtered = props.branches

    // Apply search filter
    if (searchQuery.value) {
      const query = searchQuery.value.toLowerCase()
      filtered = filtered.filter(branch =>
        branch.name.toLowerCase().includes(query) ||
        branch.address.toLowerCase().includes(query)
      )
    }

    // Filter by open status
    if (showOpenOnly.value) {
      filtered = filtered.filter(branch => isOpen(branch.opening_hours))
    }

    // Filter by delivery availability
    if (deliveryOnly.value) {
      filtered = filtered.filter(branch => isDeliveryAvailable(branch))
    }

    // Apply sorting
    return filtered.sort((a, b) => {
      if (sortOrder.value === 'distance') {
        return (a.distance || Infinity) - (b.distance || Infinity)
      }
      return a.name.localeCompare(b.name)
    })
  })

  // Utility functions - using your existing implementations
  const isOpen = (hours) => {
    if (!hours) return false
    const now = new Date()
    const day = now.toLocaleDateString('en-US', { weekday: 'long' })
    const time = now.toLocaleTimeString('en-US', { hour12: false })
    const todayHours = hours.find(h => h.day === day)
    return todayHours ? time >= todayHours.open && time <= todayHours.close : false
  }

  const isDeliveryAvailable = (branch) => {
    if (!branch.distance || !branch.delivery_radius) return true
    return branch.distance <= branch.delivery_radius
  }

  const formatDistance = (distance) => {
    if (!distance) return 'Distance unknown'
    return `${distance.toFixed(1)} km away`
  }

  const getDirectionsUrl = (branch) => {
    const destination = `${branch.latitude},${branch.longitude}`
    return `https://www.google.com/maps/dir/?api=1&destination=${destination}`
  }
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
