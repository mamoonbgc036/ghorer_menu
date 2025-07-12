<template>
  <CustomerLayout>
    <div class="max-w-7xl mx-auto px-4 sm:px-6">
      <!-- Branch Info Header -->
      <div class="bg-white dark:bg-gray-800 rounded-lg shadow-sm p-6">
        <div class="flex flex-col lg:flex-row lg:items-center lg:justify-between">
          <div class="flex-1">
            <h1 class="text-2xl font-bold text-gray-900 dark:text-gray-100">{{ branch.name }}</h1>
            <div class="mt-2 flex flex-wrap items-center gap-4">
              <span class="inline-flex items-center text-gray-600 dark:text-gray-400">
                <i class="fas fa-map-marker-alt mr-2"></i>
                {{ branch.address }}
              </span>
              <span class="inline-flex items-center text-gray-600 dark:text-gray-400">
                <i class="fas fa-phone mr-2"></i>
                {{ branch.contact_number }}
              </span>
              <span
                :class="[
                                'inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium',
                                isRestaurantOpen
                                    ? 'bg-green-100 text-green-800 dark:bg-green-900/50 dark:text-green-300'
                                    : 'bg-red-100 text-red-800 dark:bg-red-900/50 dark:text-red-300'
                            ]"
              >{{ isRestaurantOpen ? 'Open Now' : 'Closed' }}</span>
            </div>
          </div>

          <div class="mt-4 lg:mt-0">
            <div class="flex flex-col items-end">
              <!-- Order Type Dropdown -->
              <label
                for="orderType"
                class="mb-1 text-sm text-gray-700 dark:text-gray-300 font-medium"
              >Order Type</label>
              <select
                id="orderType"
                v-model="orderType"
                class="w-48 px-4 py-2 rounded-lg border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-800 text-gray-700 dark:text-gray-200 focus:outline-none focus:ring-2 focus:ring-indigo-500"
              >
                <option value="delivery">Delivery</option>
                <option value="collection">Collection</option>
              </select>
            </div>
          </div>
        </div>
      </div>
      <div class="min-h-screen bg-gray-50 dark:bg-gray-900 w-full">
        <div class="container mx-auto px-4 py-8">
          <div class="grid grid-cols-1 lg:grid-cols-4 gap-6">
            <!-- Categories Sidebar -->
            <aside class="lg:col-span-1">
              <div class="bg-white dark:bg-gray-800 rounded-2xl shadow-lg sticky top-24 p-6">
                <h2 class="text-2xl font-bold text-gray-900 dark:text-white mb-4">Menu Categories</h2>
                <nav class="space-y-2">
                  <button
                    v-for="category in categories"
                    :key="category.id"
                    @click="scrollToCategory(category.id)"
                    class="w-full text-left px-4 py-3 rounded-lg transition-all duration-200 flex justify-between items-center text-gray-600 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700"
                    :class="{ 'bg-indigo-100 dark:bg-indigo-900/30 text-indigo-600 dark:text-indigo-300': activeCategory === category.id }"
                  >
                    <span class="font-medium">{{ category.name }}</span>
                    <span
                      class="text-sm bg-indigo-50 dark:bg-indigo-900/20 px-2.5 py-1 rounded-full"
                    >{{ getFoodsByCategory(category.id).length }}</span>
                  </button>
                </nav>
              </div>
            </aside>

            <!-- Food Items Grid -->
            <main class="lg:col-span-2 rounded-2xl bg-white dark:bg-gray-900 shadow-md">
              <section
                v-for="category in categories"
                :key="category.id"
                :id="`category-${category.id}`"
                class="scroll-mt-24 mb-8"
              >
                <div class="dark:bg-gray-800 text-center rounded-t-2xl">
                  <h2 class="text-3xl font-bold text-gray-900 dark:text-white">{{ category.name }}</h2>
                  <p
                    class="text-gray-600 dark:text-gray-400 leading-relaxed"
                  >{{ category.description }}</p>
                </div>

                <div class="grid grid-cols-1 gap-6">
                  <article
                    v-for="food in filteredFoodsByCategory(category.id)"
                    :key="food.id"
                    class="bg-white dark:bg-gray-800 shadow-md overflow-hidden hover:shadow-xl transition-all duration-300 transform hover:-translate-y-1 rounded-b-2xl"
                  >
                    <!-- Food Image -->
                    <div class="relative h-56">
                      <img
                        v-if="food.image_path"
                        :src="getImageUrl(food.image_path)"
                        :alt="food.name"
                        class="w-full h-full object-cover"
                      />
                      <div
                        v-if="!food.is_available"
                        class="absolute inset-0 bg-black bg-opacity-60 flex items-center justify-center"
                      >
                        <span class="text-white font-semibold text-lg">Currently Unavailable</span>
                      </div>
                    </div>

                    <!-- Food Info -->
                    <div class="p-6">
                      <div class="flex justify-between items-start mb-4">
                        <div>
                          <h3
                            class="text-xl font-semibold text-gray-900 dark:text-white"
                          >{{ food.name }}</h3>
                          <p
                            class="text-gray-600 dark:text-gray-400 line-clamp-2"
                          >{{ food.description }}</p>
                        </div>
                        <div class="flex space-x-2 items-center">
                          <i
                            v-if="food.is_vegetarian"
                            class="fas fa-leaf text-green-500 text-lg"
                            title="Vegetarian"
                          ></i>
                          <i
                            v-if="food.is_spicy"
                            class="fas fa-pepper-hot text-red-500 text-lg"
                            title="Spicy"
                          ></i>
                        </div>
                      </div>

                      <!-- Food Details -->
                      <div class="space-y-2 text-sm text-gray-600 dark:text-gray-400 mb-4">
                        <div class="flex items-center gap-2">
                          <i class="fas fa-clock w-5 text-indigo-500"></i>
                          <span>Prep time: {{ food.preparation_time }} mins</span>
                        </div>
                        <div v-if="food.allergens?.length" class="flex items-center gap-2">
                          <i class="fas fa-exclamation-circle w-5 text-amber-500"></i>
                          <span>Allergens: {{ food.allergens.join(', ') }}</span>
                        </div>
                      </div>

                      <!-- Price and Action -->
                      <div
                        class="flex justify-between items-center border-t border-gray-200 dark:border-gray-700 pt-4"
                      >
                        <div class="flex items-center gap-3">
                          <span
                            class="text-xl font-bold text-gray-900 dark:text-white"
                          >৳{{ food.base_price }}</span>
                          <span
                            v-if="food.original_price"
                            class="text-sm text-gray-500 dark:text-gray-400 line-through"
                          >৳{{ food.original_price }}</span>
                        </div>
                        <button
                          @click="openFoodModal(food)"
                          :disabled="!food.is_available"
                          class="inline-flex items-center px-5 py-2.5 rounded-lg text-sm font-medium transition-colors duration-200"
                          :class="[
                      food.is_available
                        ? 'bg-indigo-600 text-white hover:bg-indigo-700'
                        : 'bg-gray-300 text-gray-500 cursor-not-allowed'
                    ]"
                        >{{ food.is_available ? 'Add to Order' : 'Not Available' }}</button>
                      </div>
                    </div>
                  </article>
                </div>
              </section>
            </main>

            <div class="lg:col-span-1">
              <div
                v-for="(items, index) in selectedFood"
                :key="index"
                :class="['bg-white dark:bg-gray-800 rounded-2xl shadow-lg top-24 p-6', index > 0 ? 'mt-2' : '']"
              >
                <div class="relative flex">
                  <div>
                    <h2
                      class="text-xl font-semibold text-gray-900 dark:text-white mb-2"
                    >{{ items.name }}</h2>
                    <p class="text-sm text-gray-500 dark:text-gray-400 mb-4">{{ items.description }}</p>
                  </div>
                  <button
                    @click="deleteItem(items.id)"
                    class="absolute top-0 right-0 text-2xl text-white bg-red-600 hover:bg-red-700 rounded-full w-7 h-7 flex items-center justify-center shadow-lg"
                    title="Remove"
                  >×</button>
                </div>
                <div class="mb-4">
                  <label
                    class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1"
                  >Select Portion</label>
                  <div class="flex gap-4">
                    <label
                      class="flex items-center space-x-2 text-sm text-gray-700 dark:text-gray-300"
                    >
                      <input
                        type="radio"
                        :name="`portion-${items.id}`"
                        value="full"
                        class="form-radio text-indigo-600"
                        v-model="items.portion"
                      />
                      <span>Full</span>
                    </label>
                    <label
                      class="flex items-center space-x-2 text-sm text-gray-700 dark:text-gray-300"
                    >
                      <input
                        type="radio"
                        :name="`portion-${items.id}`"
                        value="half"
                        class="form-radio text-indigo-600"
                        v-model="items.portion"
                      />
                      <span>Half</span>
                    </label>
                  </div>
                </div>

                <!-- Quantity Control -->
                <div class="flex items-center gap-3 mb-4">
                  <span class="text-sm text-gray-600 dark:text-gray-300">Quantity</span>
                  <div class="flex items-center border rounded-lg px-2 py-1 w-fit">
                    <button
                      @click="decreament(items.id)"
                      class="text-indigo-600 text-xl font-bold px-2"
                    >−</button>
                    <span class="px-2 text-gray-900 dark:text-white">{{ items?.qty }}</span>
                    <button
                      @click="increament(items.id)"
                      class="text-indigo-600 text-xl font-bold px-2"
                    >+</button>
                  </div>
                </div>

                <!-- Special Instructions -->
                <div class="mb-4">
                  <label
                    class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1"
                  >Special Instructions</label>
                  <textarea
                    v-model="items.instructions"
                    @input="updateInstruction(items.id, $event.target.value)"
                    rows="2"
                    class="w-full border rounded-lg p-2 text-sm text-gray-800 dark:text-gray-100 dark:bg-gray-700"
                    placeholder="Any special requests?"
                  ></textarea>
                </div>

                <!-- Total -->
                <div class="flex justify-between items-center mb-4">
                  <span class="text-lg font-semibold text-gray-900 dark:text-white">Total:</span>
                  <span class="text-lg font-bold text-gray-900 dark:text-white">৳ {{ items.total }}</span>
                </div>
              </div>
              <div v-if="selectedFood.length > 0">
                <div class="mt-4 p-4 bg-white dark:bg-gray-800 rounded-2xl shadow-md text-center">
                  <span class="text-lg font-semibold text-gray-700 dark:text-gray-300">Sub Total:</span>
                  <span
                    class="text-xl font-bold text-indigo-600 dark:text-indigo-400 ml-2"
                  >৳ {{ subTotal }}</span>
                </div>

                <button
                  @click="handleCheckout"
                  :disabled="isProcessing"
                  class="w-full text-lg bg-indigo-600 text-white hover:bg-indigo-700 text-center px-5 py-2.5 rounded-lg transition-colors duration-200 flex justify-center items-center mt-2"
                >
                  <template v-if="isProcessing">
                    <svg
                      class="animate-spin h-5 w-5 text-white text-center"
                      xmlns="http://www.w3.org/2000/svg"
                      fill="none"
                      viewBox="0 0 24 24"
                    >
                      <circle
                        class="opacity-25"
                        cx="12"
                        cy="12"
                        r="10"
                        stroke="currentColor"
                        stroke-width="4"
                      />
                      <path
                        class="opacity-75"
                        fill="currentColor"
                        d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z"
                      />
                    </svg>
                  </template>
                  <template v-else>Proceed To Checkout</template>
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </CustomerLayout>
</template>
<script setup>
import { ref, computed, onMounted, watch } from "vue";
import { router } from "@inertiajs/vue3";
import CustomerLayout from "@/Layouts/CustomerLayout.vue";
// Props definition
const props = defineProps({
  branch: {
    type: Object,
    required: true,
  },
  categories: {
    type: Array,
    required: true,
  },
  foods: {
    type: Object,
    required: true,
  },
  orderType: {
    type: String,
    required: true,
    validator: (value) => ["delivery", "collection"].includes(value),
  },
  auth: {
    type: Object,
    default: () => ({}),
  },
});

// State Management
const isProcessing = ref(false);
const filterVegetarian = ref(false);
const filterSpicy = ref(false);
const activeCategory = ref(null);
const orderType = ref("collection");
const selectedFood = ref(
  JSON.parse(localStorage.getItem("selectedItem"))?.items ?? []
);

const updateInstruction = (id, value) => {
  let instruction_for_item = selectedFood.value.find((i) => i.id == id);
  if (instruction_for_item) {
    instruction_for_item.instructions = value;
    saveToLocalStorage(selectedFood.value);
  }
};

const subTotal = computed(() => {
  let sub_total = selectedFood.value.reduce((sum, item) => sum + item.total, 0);
  selectedFood.value.sub_total = sub_total;
  return sub_total;
});

const deleteItem = (id) => {
  const selected = selectedFood.value.filter((item) => item.id !== id);
  selectedFood.value = selected;
  saveToLocalStorage(selected);
};

const saveToLocalStorage = (selectedItemValue) => {
  localStorage.setItem(
    "selectedItem",
    JSON.stringify({
      items: selectedItemValue,
      sub_total: subTotal.value,
      order_type: orderType.value,
    })
  );
};

const handleCheckout = () => {
  isProcessing.value = true;
  setTimeout(function () {
    router.visit(route("customer.checkout", { branch: props.branch.id }));
  }, 1000);
};
// Modal Functions
const openFoodModal = (food) => {
  const check = selectedFood.value.some((item) => item.id === food.id);

  if (!check) {
    const selected = {
      ...food,
      qty: 1,
      total: parseInt(food.base_price),
      portion: "full",
      instructions: "",
    };
    selectedFood.value.push(selected);
  } else {
    const preSelectedFood = selectedFood.value.find(
      (item) => item.id === food.id
    );
    preSelectedFood.qty += 1;
    preSelectedFood.total =
      preSelectedFood.qty * parseInt(preSelectedFood.base_price);
  }
  saveToLocalStorage(selectedFood.value);
};

const increament = (selectedItemId) => {
  // find clicked object
  const selectedItem = selectedFood.value.find(
    (item) => item.id == selectedItemId
  );
  // increase qty
  selectedItem.qty++;
  // increase total
  selectedItem.total = selectedItem.qty * parseInt(selectedItem.base_price);
  saveToLocalStorage(selectedFood.value);
};

const decreament = (selectedItemId) => {
  const selectedItem = selectedFood.value.find(
    (item) => item.id == selectedItemId
  );
  if (selectedItem.qty > 1) {
    selectedItem.qty--;
    selectedItem.total = selectedItem.qty * parseInt(selectedItem.base_price);
  }
  saveToLocalStorage(selectedFood.value);
};

// Restaurant Status
const isRestaurantOpen = computed(() => {
  if (!props.branch.opening_hours) return false;
  const now = new Date();
  const currentDay = now.toLocaleDateString("en-US", { weekday: "long" });
  const currentTime = now.toLocaleTimeString("en-US", { hour12: false });

  const todayHours = props.branch.opening_hours.find(
    (h) => h.day === currentDay
  );
  if (!todayHours) return false;

  return currentTime >= todayHours.open && currentTime <= todayHours.close;
});

// needed
const filteredFoodsByCategory = (categoryId) => {
  let foods = getFoodsByCategory(categoryId);
  // Apply dietary filters
  if (filterVegetarian.value) {
    foods = foods.filter((food) => food.is_vegetarian);
  }
  if (filterSpicy.value) {
    foods = foods.filter((food) => food.is_spicy);
  }

  return foods;
};

// needed
const getFoodsByCategory = (categoryId) => {
  return props.foods[categoryId] || [];
};

// Image Handling
const getImageUrl = (imagePath) => {
  if (!imagePath) return null;
  const cleanPath = imagePath.startsWith("/") ? imagePath.slice(1) : imagePath;
  return `${window.location.origin}/storage/${cleanPath}`;
};

// need for clarification
const saveCartToSession = () => {
  const cartData = {
    items: cart.value,
    branchId: props.branch.id,
    orderType: props.orderType,
    lastUpdated: new Date().toISOString(),
  };
  sessionStorage.setItem("foodCart", JSON.stringify(cartData));
};

// needed
const scrollToCategory = (categoryId) => {
  activeCategory.value = categoryId;
  const element = document.getElementById(`category-${categoryId}`);
  if (element) {
    element.scrollIntoView({ behavior: "smooth" });
  }
};
</script>
<style scoped>
/* Scroll Margin for Header Offset */
.scroll-mt-20 {
  scroll-margin-top: 5rem;
}

/* Smooth Scrolling */
:deep(html) {
  scroll-behavior: smooth;
}

/* Custom Scrollbar Styling */
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

.dark .scrollbar-thin::-webkit-scrollbar-thumb {
  background-color: rgba(156, 163, 175, 0.3);
}

/* Category Navigation Hover Effects */
.category-link {
  position: relative;
  transition: all 0.3s ease;
}

.category-link::after {
  content: "";
  position: absolute;
  bottom: -2px;
  left: 0;
  width: 0;
  height: 2px;
  background-color: rgb(79, 70, 229);
  transition: width 0.3s ease;
}

.dark .category-link::after {
  background-color: rgb(129, 140, 248);
}

.category-link:hover::after {
  width: 100%;
}

/* Card Hover Effects */
.food-card {
  transition: transform 0.2s ease, box-shadow 0.2s ease;
}

.food-card:hover {
  transform: translateY(-2px);
}

/* Modal Transitions */
.modal-enter-active,
.modal-leave-active {
  transition: opacity 0.3s ease;
}

.modal-enter-from,
.modal-leave-to {
  opacity: 0;
}

/* Fade Transitions */
.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.3s ease;
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}

/* Slide Transitions */
.slide-up-enter-active,
.slide-up-leave-active {
  transition: transform 0.3s ease-out;
}

.slide-up-enter-from,
.slide-up-leave-to {
  transform: translateY(100%);
}

/* Cart Preview Animations */
.cart-preview-enter-active,
.cart-preview-leave-active {
  transition: all 0.3s ease-out;
}

.cart-preview-enter-from,
.cart-preview-leave-to {
  transform: translateY(100%);
  opacity: 0;
}

/* List Transitions for Cart Items */
.list-move,
.list-enter-active,
.list-leave-active {
  transition: all 0.3s ease;
}

.list-enter-from,
.list-leave-to {
  opacity: 0;
  transform: translateX(-30px);
}

.list-leave-active {
  position: absolute;
}

/* Image Loading Skeleton */
.image-skeleton {
  @apply bg-gray-200 dark:bg-gray-700 animate-pulse;
}

/* Custom Button Styles */
.btn-primary {
  @apply inline-flex items-center px-4 py-2 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 disabled:opacity-50 disabled:cursor-not-allowed transition-colors duration-200;
}

.dark .btn-primary {
  @apply focus:ring-offset-gray-900;
}

.btn-secondary {
  @apply inline-flex items-center px-4 py-2 border border-gray-300 rounded-md shadow-sm text-sm font-medium text-gray-700 bg-white hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 disabled:opacity-50 disabled:cursor-not-allowed transition-colors duration-200;
}

.dark .btn-secondary {
  @apply border-gray-600 text-gray-300 bg-gray-800 hover:bg-gray-700 focus:ring-offset-gray-900;
}

/* Price Badge */
.price-badge {
  @apply inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-green-100 text-green-800;
}

.dark .price-badge {
  @apply bg-green-900/50 text-green-300;
}

/* Status Indicators */
.status-indicator {
  @apply inline-block w-2 h-2 rounded-full;
}

.status-indicator.available {
  @apply bg-green-500;
}

.status-indicator.unavailable {
  @apply bg-red-500;
}

/* Food Card Image Container */
.food-image-container {
  position: relative;
  padding-top: 66.67%;
  /* 3:2 Aspect Ratio */
  overflow: hidden;
}

.food-image-container img {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.3s ease;
}

.food-image-container:hover img {
  transform: scale(1.05);
}

/* Custom Checkbox Style */
.custom-checkbox {
  @apply form-checkbox rounded border-gray-300 text-indigo-600 focus:ring-indigo-500;
}

.dark .custom-checkbox {
  @apply border-gray-600 text-gray-400 bg-gray-800 focus:ring-offset-gray-900 focus:ring-gray-600;
}

/* Quantity Input Styles */
.quantity-input {
  @apply w-16 text-center border-gray-300 rounded-md focus:ring-indigo-500 focus:border-indigo-500;
}

.dark .quantity-input {
  @apply border-gray-600 bg-gray-800 text-gray-300;
}

/* Special Instructions Textarea */
.special-instructions {
  @apply block w-full rounded-md border-gray-300 shadow-sm focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm;
}

.dark .special-instructions {
  @apply border-gray-600 bg-gray-800 text-gray-300;
}

/* Mobile Optimizations */
@media (max-width: 640px) {
  .food-grid {
    grid-template-columns: repeat(1, minmax(0, 1fr));
  }

  .cart-preview {
    padding-bottom: env(safe-area-inset-bottom);
  }
}

/* Print Styles */
@media print {
  .no-print {
    display: none;
  }

  .print-only {
    display: block;
  }
}

/* Accessibility */
@media (prefers-reduced-motion: reduce) {
  *,
  *::before,
  *::after {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
    scroll-behavior: auto !important;
  }
}
</style>
