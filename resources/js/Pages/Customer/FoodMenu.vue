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
              <span
                class="text-lg font-medium text-gray-900 dark:text-gray-100"
              >{{ orderType === 'delivery' ? 'Delivery' : 'Collection' }} Order</span>
              <span
                v-if="orderType === 'delivery'"
                class="text-sm text-gray-600 dark:text-gray-400"
              >Delivery within {{ branch.delivery_radius }}km</span>
              <span
                class="text-sm text-gray-600 dark:text-gray-400"
              >Min. order: ৳{{ branch.minimum_order }}</span>
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
                <h2
                  class="text-xl font-semibold text-gray-900 dark:text-white mb-2"
                >{{ items.name }}</h2>
                <p class="text-sm text-gray-500 dark:text-gray-400 mb-4">{{ items.description }}</p>

                <!-- Portion Selection -->
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
              <div
                v-if="selectedFood.length > 0"
                class="mt-4 p-4 bg-white dark:bg-gray-800 rounded-2xl shadow-md text-center"
              >
                <span class="text-lg font-semibold text-gray-700 dark:text-gray-300">Sub Total:</span>
                <span
                  class="text-xl font-bold text-indigo-600 dark:text-indigo-400 ml-2"
                >৳ {{ subTotal }}</span>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Authentication Modal -->
      <AuthModal v-model="showAuthModal" :redirect-path="currentPath" />

      <!-- Cart Preview -->
      <Transition
        enter-active-class="transform transition ease-out duration-300"
        enter-from-class="translate-y-full"
        enter-to-class="translate-y-0"
        leave-active-class="transform transition ease-in duration-300"
        leave-from-class="translate-y-0"
        leave-to-class="translate-y-full"
      >
        <div v-if="cart.length > 0" class="fixed bottom-0 inset-x-0 pb-safe z-40">
          <div
            class="bg-white dark:bg-gray-800 shadow-lg border-t border-gray-200 dark:border-gray-700"
          >
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-4">
              <div class="flex items-center justify-between">
                <div class="flex items-center space-x-4">
                  <div class="flex items-center">
                    <span
                      class="text-lg font-medium text-gray-900 dark:text-gray-100"
                    >{{ cart.length }} {{ cart.length === 1 ? 'item' : 'items' }}</span>
                  </div>
                  <div class="h-6 w-px bg-gray-200 dark:bg-gray-700"></div>
                  <div class="flex items-center">
                    <span
                      class="text-lg font-medium text-gray-900 dark:text-gray-100"
                    >Total: ৳{{ cartTotal }}</span>
                  </div>
                </div>

                <div class="flex items-center space-x-4">
                  <button
                    @click="clearCart"
                    class="inline-flex items-center px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-md text-sm font-medium text-gray-700 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700"
                  >
                    <i class="fas fa-trash-alt mr-2"></i>
                    Clear
                  </button>

                  <button
                    @click="proceedToCheckout"
                    class="inline-flex items-center px-6 py-2 border border-transparent rounded-md shadow-sm text-base font-medium text-white bg-indigo-600 hover:bg-indigo-700"
                  >
                    <i class="fas fa-shopping-cart mr-2"></i>
                    Checkout
                  </button>
                </div>
              </div>

              <!-- Mini Cart Items Preview -->
              <div v-if="showMiniCart" class="mt-4 space-y-2 max-h-60 overflow-y-auto">
                <div
                  v-for="item in cart"
                  :key="item.id"
                  class="flex items-center justify-between py-2 border-t border-gray-200 dark:border-gray-700"
                >
                  <div class="flex items-center">
                    <span class="text-gray-600 dark:text-gray-400">{{ item.quantity }}x</span>
                    <span class="ml-2 text-gray-900 dark:text-gray-100">{{ item.food.name }}</span>
                    <span
                      v-if="item.extras.length"
                      class="ml-2 text-sm text-gray-500 dark:text-gray-400"
                    >({{ item.extras.map(e => e.name).join(', ') }})</span>
                  </div>
                  <div class="flex items-center space-x-4">
                    <span class="text-gray-900 dark:text-gray-100">
                      ৳{{ item.total.toFixed(2)
                      }}
                    </span>
                    <button
                      @click="removeFromCart(item.id)"
                      class="text-red-500 hover:text-red-600"
                    >
                      <i class="fas fa-times"></i>
                    </button>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </Transition>
    </div>
  </CustomerLayout>
</template>
<script setup>
import { ref, computed, onMounted, watch } from "vue";
import { router } from "@inertiajs/vue3";
import CustomerLayout from "@/Layouts/CustomerLayout.vue";
import AuthModal from "@/Components/Auth/AuthModal.vue";

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
const searchQuery = ref("");
const filterVegetarian = ref(false);
const filterSpicy = ref(false);
const activeCategory = ref(null);
const isModalOpen = ref(false);
const showAuthModal = ref(false);
const showMiniCart = ref(false);
const selectedFood = ref([]);
const selectedExtras = ref([]);
const quantity = ref(1);
const specialInstructions = ref("");
const cart = ref([]);

const subTotal = computed(() => {
  let sub_total = selectedFood.value.reduce((sum, item) => sum + item.total, 0);
  selectedFood.value.sub_total = sub_total;
  return sub_total;
});

const increament = (selectedItemId) => {
  // find clicked object
  const selectedItem = selectedFood.value.find(
    (item) => item.id == selectedItemId
  );
  // increase qty
  selectedItem.qty++;
  // increase total
  selectedItem.total = selectedItem.qty * parseInt(selectedItem.base_price);
};

const decreament = (selectedItemId) => {
  const selectedItem = selectedFood.value.find(
    (item) => item.id == selectedItemId
  );
  if (selectedItem.qty > 1) {
    selectedItem.qty--;
    selectedItem.total = selectedItem.qty * parseInt(selectedItem.base_price);
  }
};

const redirectToLogin = () => {
  // Save the current full path including query parameters
  sessionStorage.setItem(
    "redirect_after_auth",
    window.location.pathname + window.location.search
  );
  router.visit(route("login"));
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

// Computed Properties
const cartTotal = computed(() => {
  let subTtotal = cart.value
    .reduce((total, item) => total + item.total, 0)
    .toFixed(2);
  return subTotal;
});

const calculateTotal = computed(() => {
  if (!selectedFood.value) return "0.00";

  let total = parseFloat(selectedFood.value.base_price);

  // Add extras
  selectedExtras.value.forEach((extraId) => {
    const extra = selectedFood.value.extra_options.find(
      (opt) => opt.id === extraId
    );
    if (extra) {
      total += parseFloat(extra.price);
    }
  });

  return (total * quantity.value).toFixed(2);
});

// Filter Functions
const filteredFoodsByCategory = (categoryId) => {
  let foods = getFoodsByCategory(categoryId);

  // Apply search filter
  if (searchQuery.value) {
    const query = searchQuery.value.toLowerCase();
    foods = foods.filter(
      (food) =>
        food.name.toLowerCase().includes(query) ||
        food.description.toLowerCase().includes(query)
    );
  }

  // Apply dietary filters
  if (filterVegetarian.value) {
    foods = foods.filter((food) => food.is_vegetarian);
  }
  if (filterSpicy.value) {
    foods = foods.filter((food) => food.is_spicy);
  }

  return foods;
};

const getFoodsByCategory = (categoryId) => {
  return props.foods[categoryId] || [];
};

// Image Handling
const getImageUrl = (imagePath) => {
  if (!imagePath) return null;
  const cleanPath = imagePath.startsWith("/") ? imagePath.slice(1) : imagePath;
  return `${window.location.origin}/storage/${cleanPath}`;
};

// Modal Functions
const openFoodModal = (food) => {
  // check whether the food is exist in selectedFood
  const check = selectedFood.value.some((item) => item.id == food.id);
  if (!check) {
    food.qty = 1;
    food.total = parseInt(food.base_price);
    food.portion = "full";
    console.log(food);
    selectedFood.value.push(food);
  } else {
    const preSelectedFood = selectedFood.value.find(
      (item) => item.id == food.id
    );
    preSelectedFood.qty++;
    preSelectedFood.total =
      preSelectedFood.qty * parseInt(preSelectedFood.base_price);
  }

  // check existing selectedFood for the clicked food
  // const check = selectedFood.value.some(item => item.)
  // if found in existing increase it quantity
  // if no found in existing, add a new card
  selectedExtras.value = [];
  quantity.value = 1;
  specialInstructions.value = "";
  isModalOpen.value = true;
};

const closeModal = () => {
  isModalOpen.value = false;
  setTimeout(() => {
    selectedFood.value = null;
    selectedExtras.value = [];
    quantity.value = 1;
    specialInstructions.value = "";
  }, 300);
};

const closeAuthModal = () => {
  showAuthModal.value = false;
};

const addToCart = () => {
  const extras = selectedFood.value.extra_options.filter((opt) =>
    selectedExtras.value.includes(opt.id)
  );

  const cartItem = {
    id: Date.now(), // Unique identifier
    food: selectedFood.value,
    quantity: quantity.value,
    extras: extras,
    specialInstructions: specialInstructions.value,
    total: parseFloat(calculateTotal.value),
    type: route().params.type, // Get the type from route params (delivery/collection)
  };

  cart.value.push(cartItem);
  saveCartToSession();
  closeModal();
};

const removeFromCart = (itemId) => {
  cart.value = cart.value.filter((item) => item.id !== itemId);
  saveCartToSession();
};

const clearCart = () => {
  cart.value = [];
  sessionStorage.removeItem("foodCart");
};

const saveCartToSession = () => {
  const cartData = {
    items: cart.value,
    branchId: props.branch.id,
    orderType: props.orderType,
    lastUpdated: new Date().toISOString(),
  };
  sessionStorage.setItem("foodCart", JSON.stringify(cartData));
};

// Navigation Functions
const scrollToCategory = (categoryId) => {
  activeCategory.value = categoryId;
  const element = document.getElementById(`category-${categoryId}`);
  if (element) {
    element.scrollIntoView({ behavior: "smooth" });
  }
};

const redirectToRegister = () => {
  sessionStorage.setItem("redirect_after_auth", window.location.pathname);
  router.visit(route("register"));
};

const proceedToCheckout = () => {
  if (!props.auth?.user) {
    showAuthModal.value = true;
    return;
  }

  if (cart.value.length === 0) {
    return;
  }

  if (cartTotal.value < props.branch.minimum_order) {
    alert(`Minimum order amount is ৳${props.branch.minimum_order}`);
    return;
  }

  saveCartToSession();
  router.visit(route("customer.checkout", { branch: props.branch.id }));
};

// Intersection Observer for Category Highlighting
const setupCategoryObserver = () => {
  const observer = new IntersectionObserver(
    (entries) => {
      entries.forEach((entry) => {
        if (entry.isIntersecting) {
          const categoryId = parseInt(entry.target.id.replace("category-", ""));
          activeCategory.value = categoryId;
        }
      });
    },
    { threshold: 0.3 }
  );

  props.categories.forEach((category) => {
    const element = document.getElementById(`category-${category.id}`);
    if (element) observer.observe(element);
  });
};

// Lifecycle Hooks
onMounted(() => {
  // Set initial active category
  if (props.categories.length > 0) {
    activeCategory.value = props.categories[0].id;
  }

  // Load saved cart
  const savedCart = sessionStorage.getItem("foodCart");
  if (savedCart) {
    try {
      const cartData = JSON.parse(savedCart);
      if (cartData.branchId === props.branch.id) {
        cart.value = cartData.items;
      }
    } catch (error) {
      console.error("Error loading cart:", error);
      sessionStorage.removeItem("foodCart");
    }
  }

  setupCategoryObserver();
});

// Watchers
watch(
  cart,
  () => {
    showMiniCart.value = cart.value.length > 0;
  },
  { deep: true }
);
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
