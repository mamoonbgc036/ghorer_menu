<template>
    <TransitionRoot appear :show="modelValue" as="template">
        <Dialog as="div" @close="closeModal" class="relative z-50">
            <!-- Backdrop -->
            <div class="fixed inset-0 bg-black/50" aria-hidden="true" />

            <!-- Modal Container -->
            <div class="fixed inset-0 overflow-y-auto">
                <div class="flex min-h-full items-center justify-center p-4">
                    <DialogPanel
                        class="w-full max-w-md transform overflow-hidden rounded-2xl bg-white dark:bg-gray-800 p-6 shadow-xl transition-all">
                        <!-- Tab Navigation -->
                        <div class="flex space-x-4 border-b border-gray-200 dark:border-gray-700 mb-6">
                            <button @click="activeTab = 'login'"
                                class="pb-4 px-2 text-sm font-medium transition-colors relative" :class="[
                                    activeTab === 'login'
                                        ? 'text-orange-600 dark:text-orange-400'
                                        : 'text-gray-500 dark:text-gray-400 hover:text-gray-700 dark:hover:text-gray-300'
                                ]">
                                Sign In
                                <span class="absolute bottom-0 left-0 w-full h-0.5 transition-colors" :class="[
                                    activeTab === 'login'
                                        ? 'bg-orange-600 dark:bg-orange-400'
                                        : 'bg-transparent'
                                ]" />
                            </button>
                            <button @click="activeTab = 'register'"
                                class="pb-4 px-2 text-sm font-medium transition-colors relative" :class="[
                                    activeTab === 'register'
                                        ? 'text-orange-600 dark:text-orange-400'
                                        : 'text-gray-500 dark:text-gray-400 hover:text-gray-700 dark:hover:text-gray-300'
                                ]">
                                Register
                                <span class="absolute bottom-0 left-0 w-full h-0.5 transition-colors" :class="[
                                    activeTab === 'register'
                                        ? 'bg-orange-600 dark:bg-orange-400'
                                        : 'bg-transparent'
                                ]" />
                            </button>
                        </div>

                        <!-- Login Form -->
                        <form v-if="activeTab === 'login'" @submit.prevent="handleLogin">
                            <div class="space-y-4">
                                <div>
                                    <label class="block text-sm font-medium text-gray-700 dark:text-gray-300">
                                        Email
                                    </label>
                                    <input type="email" v-model="loginForm.email" required
                                        class="mt-1 block w-full rounded-md border-gray-300 dark:border-gray-600 dark:bg-gray-700 shadow-sm focus:border-orange-500 focus:ring-orange-500" />
                                    <div v-if="loginForm.errors.email" class="mt-1 text-sm text-red-600">
                                        {{ loginForm.errors.email }}
                                    </div>
                                </div>

                                <div>
                                    <label class="block text-sm font-medium text-gray-700 dark:text-gray-300">
                                        Password
                                    </label>
                                    <input type="password" v-model="loginForm.password" required
                                        class="mt-1 block w-full rounded-md border-gray-300 dark:border-gray-600 dark:bg-gray-700 shadow-sm focus:border-orange-500 focus:ring-orange-500" />
                                    <div v-if="loginForm.errors.password" class="mt-1 text-sm text-red-600">
                                        {{ loginForm.errors.password }}
                                    </div>
                                </div>

                                <div class="flex items-center justify-between">
                                    <label class="flex items-center">
                                        <input type="checkbox" v-model="loginForm.remember"
                                            class="rounded border-gray-300 text-orange-600 shadow-sm focus:border-orange-500 focus:ring-orange-500" />
                                        <span class="ml-2 text-sm text-gray-600 dark:text-gray-400">Remember me</span>
                                    </label>

                                    <a href="#" class="text-sm text-orange-600 hover:text-orange-500">
                                        Forgot password?
                                    </a>
                                </div>

                                <button type="submit"
                                    class="w-full flex justify-center py-2 px-4 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-orange-600 hover:bg-orange-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-orange-500"
                                    :disabled="loginForm.processing">
                                    Sign In
                                </button>
                            </div>
                        </form>

                        <!-- Register Form -->
                        <form v-if="activeTab === 'register'" @submit.prevent="handleRegister" class="space-y-4">
                            <!-- Name -->
                            <div>
                                <label class="block text-sm font-medium text-gray-700 dark:text-gray-300">
                                    Full Name
                                </label>
                                <input type="text" v-model="registerForm.name" required
                                    class="mt-1 block w-full rounded-md border-gray-300 dark:border-gray-600 dark:bg-gray-700 shadow-sm focus:border-orange-500 focus:ring-orange-500"
                                    :class="{ 'border-red-500': registerForm.errors.name }" />
                                <div v-if="registerForm.errors.name" class="mt-1 text-sm text-red-600">
                                    {{ registerForm.errors.name }}
                                </div>
                            </div>

                            <!-- Email -->
                            <div>
                                <label class="block text-sm font-medium text-gray-700 dark:text-gray-300">
                                    Email
                                </label>
                                <input type="email" v-model="registerForm.email" required
                                    class="mt-1 block w-full rounded-md border-gray-300 dark:border-gray-600 dark:bg-gray-700 shadow-sm focus:border-orange-500 focus:ring-orange-500"
                                    :class="{ 'border-red-500': registerForm.errors.email }" />
                                <div v-if="registerForm.errors.email" class="mt-1 text-sm text-red-600">
                                    {{ registerForm.errors.email }}
                                </div>
                            </div>

                            <!-- Phone -->
                            <div>
                                <label class="block text-sm font-medium text-gray-700 dark:text-gray-300">
                                    Phone Number
                                </label>
                                <input type="tel" v-model="registerForm.phone" required
                                    class="mt-1 block w-full rounded-md border-gray-300 dark:border-gray-600 dark:bg-gray-700 shadow-sm focus:border-orange-500 focus:ring-orange-500"
                                    :class="{ 'border-red-500': registerForm.errors.phone }" />
                                <div v-if="registerForm.errors.phone" class="mt-1 text-sm text-red-600">
                                    {{ registerForm.errors.phone }}
                                </div>
                            </div>

                            <!-- Address -->
                            <div>
                                <label class="block text-sm font-medium text-gray-700 dark:text-gray-300">
                                    Delivery Address
                                </label>
                                <textarea v-model="registerForm.address" required rows="3"
                                    class="mt-1 block w-full rounded-md border-gray-300 dark:border-gray-600 dark:bg-gray-700 shadow-sm focus:border-orange-500 focus:ring-orange-500"
                                    :class="{ 'border-red-500': registerForm.errors.address }"></textarea>
                                <div v-if="registerForm.errors.address" class="mt-1 text-sm text-red-600">
                                    {{ registerForm.errors.address }}
                                </div>
                            </div>

                            <!-- Password -->
                            <div>
                                <label class="block text-sm font-medium text-gray-700 dark:text-gray-300">
                                    Password
                                </label>
                                <input type="password" v-model="registerForm.password" required
                                    class="mt-1 block w-full rounded-md border-gray-300 dark:border-gray-600 dark:bg-gray-700 shadow-sm focus:border-orange-500 focus:ring-orange-500"
                                    :class="{ 'border-red-500': registerForm.errors.password }" />
                                <div v-if="registerForm.errors.password" class="mt-1 text-sm text-red-600">
                                    {{ registerForm.errors.password }}
                                </div>
                            </div>

                            <!-- Confirm Password -->
                            <div>
                                <label class="block text-sm font-medium text-gray-700 dark:text-gray-300">
                                    Confirm Password
                                </label>
                                <input type="password" v-model="registerForm.password_confirmation" required
                                    class="mt-1 block w-full rounded-md border-gray-300 dark:border-gray-600 dark:bg-gray-700 shadow-sm focus:border-orange-500 focus:ring-orange-500" />
                            </div>

                            <!-- Terms & Conditions -->
                            <div class="flex items-center">
                                <input type="checkbox" v-model="registerForm.terms" required
                                    class="h-4 w-4 rounded border-gray-300 text-orange-600 focus:ring-orange-500" />
                                <label class="ml-2 block text-sm text-gray-700 dark:text-gray-300">
                                    I agree to the
                                    <a href="#" class="text-orange-600 hover:text-orange-500">Terms and Conditions</a>
                                </label>
                            </div>

                            <button type="submit"
                                class="w-full flex justify-center py-2 px-4 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-orange-600 hover:bg-orange-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-orange-500"
                                :disabled="registerForm.processing">
                                <span v-if="registerForm.processing">
                                    <i class="fas fa-spinner fa-spin mr-2"></i> Registering...
                                </span>
                                <span v-else>Register</span>
                            </button>
                        </form>
                    </DialogPanel>
                </div>
            </div>
        </Dialog>
    </TransitionRoot>
</template>

<script setup>
import { ref } from 'vue'
import { Dialog, DialogPanel, TransitionRoot } from '@headlessui/vue'
import { useForm } from '@inertiajs/vue3'

const props = defineProps({
    modelValue: Boolean,
    redirectUrl: {
        type: String,
        default: ''
    }
})

const emit = defineEmits(['update:modelValue'])

const activeTab = ref('login')

const loginForm = useForm({
    email: '',
    password: '',
    remember: false,
    redirect_url: props.redirectUrl
})

const registerForm = useForm({
    name: '',
  email: '',
  phone: '',
  address: '',
  password: '',
  password_confirmation: '',
  terms: false,
  role: 'customer', // Default role
  redirect: props.redirectPath
})

const closeModal = () => {
    emit('update:modelValue', false)
}

const handleLogin = () => {
    loginForm.post(route('login'), {
        onSuccess: () => {
            closeModal()
        }
    })
}

const handleRegister = () => {
    registerForm.post(route('register'), {
        onSuccess: () => {
            closeModal()
        }
    })
}
</script>
