<template>
    <AdminLayout :title="title">
        <template #header>
            <h2 class="text-xl font-semibold leading-tight text-gray-800 dark:text-gray-200">
                {{ title }}
            </h2>
        </template>

        <div class="py-12">
            <div class="max-w-7xl mx-auto sm:px-6 lg:px-8">
                <div class="bg-white dark:bg-gray-800 overflow-hidden shadow-sm sm:rounded-lg">
                    <form @submit.prevent="submit" class="p-6 space-y-6">
                        <!-- Basic Information Section -->
                        <div class="bg-gray-50 dark:bg-gray-700 p-6 rounded-lg">
                            <h3 class="text-lg font-medium text-gray-900 dark:text-gray-100 mb-4">
                                Basic Information
                            </h3>

                            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                                <!-- Branch Name -->
                                <div>
                                    <InputLabel for="name" value="Branch Name" />
                                    <TextInput id="name" v-model="form.name" type="text"
                                        class="mt-1 block w-full dark:bg-gray-900 dark:text-gray-300" required />
                                    <InputError :message="form.errors.name" class="mt-2" />
                                </div>

                                <!-- Contact Number -->
                                <div>
                                    <InputLabel for="contact_number" value="Contact Number" />
                                    <TextInput id="contact_number" v-model="form.contact_number" type="text"
                                        class="mt-1 block w-full dark:bg-gray-900 dark:text-gray-300" required />
                                    <InputError :message="form.errors.contact_number" class="mt-2" />
                                </div>

                                <!-- Address -->
                                <div class="md:col-span-2">
                                    <InputLabel for="address" value="Address" />
                                    <TextArea id="address" v-model="form.address"
                                        class="mt-1 block w-full dark:bg-gray-900 dark:text-gray-300" rows="2"
                                        required />
                                    <InputError :message="form.errors.address" class="mt-2" />
                                </div>
                            </div>
                        </div>

                        <!-- Location Section -->
                        <div class="bg-gray-50 dark:bg-gray-700 p-6 rounded-lg">
                            <h3 class="text-lg font-medium text-gray-900 dark:text-gray-100 mb-4">
                                Location & Delivery Area
                            </h3>

                            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                                <!-- Latitude -->
                                <div>
                                    <InputLabel for="latitude" value="Latitude" />
                                    <TextInput id="latitude" v-model="form.latitude" type="number" step="any"
                                        class="mt-1 block w-full dark:bg-gray-900 dark:text-gray-300" required />
                                    <InputError :message="form.errors.latitude" class="mt-2" />
                                </div>

                                <!-- Longitude -->
                                <div>
                                    <InputLabel for="longitude" value="Longitude" />
                                    <TextInput id="longitude" v-model="form.longitude" type="number" step="any"
                                        class="mt-1 block w-full dark:bg-gray-900 dark:text-gray-300" required />
                                    <InputError :message="form.errors.longitude" class="mt-2" />
                                </div>

                                <!-- Delivery Radius -->
                                <div class="md:col-span-2">
                                    <InputLabel for="delivery_radius" value="Delivery Radius (km)" />
                                    <div class="mt-1 flex items-center space-x-4">
                                        <input type="range" id="delivery_radius" v-model="form.delivery_radius" min="1"
                                            max="50"
                                            class="w-full h-2 bg-gray-200 dark:bg-gray-700 rounded-lg appearance-none cursor-pointer" />
                                        <span class="text-sm text-gray-600 dark:text-gray-300 w-12">
                                            {{ form.delivery_radius }}km
                                        </span>
                                    </div>
                                    <InputError :message="form.errors.delivery_radius" class="mt-2" />
                                </div>
                            </div>
                        </div>

                        <!-- Opening Hours Section -->
                        <div class="bg-gray-50 dark:bg-gray-700 p-6 rounded-lg">
                            <h3 class="text-lg font-medium text-gray-900 dark:text-gray-100 mb-4">
                                Opening Hours
                            </h3>

                            <div class="space-y-4">
                                <div v-for="(hours, index) in form.opening_hours" :key="index"
                                    class="flex items-start space-x-4">
                                    <!-- Day -->
                                    <div class="w-32">
                                        <InputLabel :for="`day-${index}`" value="Day" />
                                        <select :id="`day-${index}`" v-model="hours.day"
                                            class="mt-1 block w-full dark:bg-gray-900 dark:text-gray-300" required>
                                            <option v-for="day in weekDays" :key="day" :value="day">
                                                {{ day }}
                                            </option>
                                        </select>
                                    </div>

                                    <!-- Opening Time -->
                                    <div>
                                        <InputLabel :for="`open-${index}`" value="Opening Time" />
                                        <TextInput :id="`open-${index}`" v-model="hours.open" type="time"
                                            class="mt-1 block w-full dark:bg-gray-900 dark:text-gray-300" required />
                                    </div>

                                    <!-- Closing Time -->
                                    <div>
                                        <InputLabel :for="`close-${index}`" value="Closing Time" />
                                        <TextInput :id="`close-${index}`" v-model="hours.close" type="time"
                                            class="mt-1 block w-full dark:bg-gray-900 dark:text-gray-300" required />
                                    </div>

                                    <!-- Remove Button -->
                                    <button type="button" @click="removeOpeningHours(index)"
                                        class="mt-7 text-red-600 dark:text-red-400 hover:text-red-800 dark:hover:text-red-300">
                                        <i class="fas fa-trash"></i>
                                    </button>
                                </div>

                                <!-- Add More Hours Button -->
                                <button type="button" @click="addOpeningHours"
                                    class="mt-2 inline-flex items-center px-4 py-2 bg-gray-800 dark:bg-gray-200 border border-transparent rounded-md font-semibold text-xs text-white dark:text-gray-800 uppercase tracking-widest hover:bg-gray-700 dark:hover:bg-white focus:bg-gray-700 dark:focus:bg-white active:bg-gray-900 dark:active:bg-gray-300 transition ease-in-out duration-150">
                                    <i class="fas fa-plus mr-2"></i>
                                    Add Opening Hours
                                </button>
                                <InputError :message="form.errors['opening_hours']" class="mt-2" />
                            </div>
                        </div>

                        <!-- Status Toggle -->
                        <div class="bg-gray-50 dark:bg-gray-700 p-6 rounded-lg">
                            <div class="flex items-center justify-between">
                                <div>
                                    <h3 class="text-lg font-medium text-gray-900 dark:text-gray-100">
                                        Branch Status
                                    </h3>
                                    <p class="text-sm text-gray-500 dark:text-gray-400">
                                        Enable or disable this branch
                                    </p>
                                </div>
                                <Toggle v-model="form.is_active" class="ml-4" />
                            </div>
                        </div>

                        <!-- Form Actions -->
                        <div class="flex items-center justify-end space-x-3">
                            <Link :href="route('admin.branches.index')"
                                class="inline-flex items-center px-4 py-2 bg-gray-200 dark:bg-gray-700 border border-transparent rounded-md font-semibold text-xs text-gray-700 dark:text-gray-300 uppercase tracking-widest hover:bg-gray-300 dark:hover:bg-gray-600 focus:bg-gray-300 dark:focus:bg-gray-600 active:bg-gray-300 dark:active:bg-gray-600">
                            Cancel
                            </Link>
                            <PrimaryButton :disabled="form.processing">
                                {{ branch ? 'Update Branch' : 'Create Branch' }}
                            </PrimaryButton>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </AdminLayout>
</template>

<script setup>
import { computed } from 'vue'
import { Link, useForm } from '@inertiajs/vue3'
import AdminLayout from '@/Layouts/AdminLayout.vue'
import InputLabel from '@/Components/InputLabel.vue'
import TextInput from '@/Components/TextInput.vue'
import TextArea from '@/Components/TextArea.vue'
import InputError from '@/Components/InputError.vue'
import PrimaryButton from '@/Components/PrimaryButton.vue'
import Toggle from '@/Components/Toggle.vue'

const props = defineProps({
    branch: {
        type: Object,
        default: null
    }
})

const title = computed(() => props.branch ? 'Edit Branch' : 'Create Branch')

const weekDays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
]

const form = useForm({
    name: props.branch?.name ?? '',
    address: props.branch?.address ?? '',
    latitude: props.branch?.latitude ?? '',
    longitude: props.branch?.longitude ?? '',
    contact_number: props.branch?.contact_number ?? '',
    opening_hours: props.branch?.opening_hours ?? [
        { day: 'Monday', open: '09:00', close: '22:00' }
    ],
    delivery_radius: props.branch?.delivery_radius ?? 5,
    is_active: props.branch?.is_active ?? true,
})

const addOpeningHours = () => {
    form.opening_hours.push({
        day: weekDays.find(day => !form.opening_hours.find(h => h.day === day)) || weekDays[0],
        open: '09:00',
        close: '22:00'
    })
}

const removeOpeningHours = (index) => {
    form.opening_hours.splice(index, 1)
}

const submit = () => {
    if (props.branch) {
        form.put(route('admin.branches.update', props.branch.id))
    } else {
        form.post(route('admin.branches.store'))
    }
}
</script>

<style scoped>
/* Custom range slider styling */
input[type="range"]::-webkit-slider-thumb {
    @apply w-4 h-4 bg-indigo-600 rounded-full appearance-none cursor-pointer;
}

input[type="range"]::-moz-range-thumb {
    @apply w-4 h-4 bg-indigo-600 rounded-full cursor-pointer;
}

.dark input[type="range"]::-webkit-slider-thumb {
    @apply bg-indigo-500;
}

.dark input[type="range"]::-moz-range-thumb {
    @apply bg-indigo-500;
}

/* Hover states */
input[type="range"]::-webkit-slider-thumb:hover {
    @apply bg-indigo-700;
}

input[type="range"]::-moz-range-thumb:hover {
    @apply bg-indigo-700;
}

.dark input[type="range"]::-webkit-slider-thumb:hover {
    @apply bg-indigo-400;
}

.dark input[type="range"]::-moz-range-thumb:hover {
    @apply bg-indigo-400;
}
/* Custom range slider styling */
input[type="range"]::-webkit-slider-thumb {
  @apply w-4 h-4 bg-indigo-600 dark:bg-indigo-500 rounded-full cursor-pointer;
}

input[type="range"]::-moz-range-thumb {
  @apply w-4 h-4 bg-indigo-600 dark:bg-indigo-500 rounded-full cursor-pointer;
}

input[type="range"]::-webkit-slider-thumb:hover {
  @apply bg-indigo-700 dark:bg-indigo-400;
}
</style>
