<template>
  <section class="min-h-screen w-full soft-bg py-12 px-4">
    <div class="max-w-7xl mx-auto bg-white rounded-3xl p-8 md:p-12 shadow-2xl">
      <h1 class="text-4xl md:text-6xl text-center font-bold text-gray-800 mb-4 tracking-tight">
        Welcome {{ hostname }} to the Greetings App!
      </h1>
      <p class="text-xl text-center text-gray-600 mb-12">
        Explore greetings from different cultures and languages.
      </p>
      
      <!-- Add new language form -->
      <div class="bg-gray-50 rounded-2xl p-6 mb-12 max-w-2xl mx-auto shadow-inner">
        <div class="flex flex-col md:flex-row gap-4">
          <input
            v-model="language"
            type="text"
            placeholder="Enter language"
            class="w-full md:w-1/3 px-4 py-3 rounded-xl bg-white shadow-sm border border-gray-200 text-gray-800 placeholder-gray-400 outline-none"
          />
          <input
            v-model="greeting"
            type="text"
            placeholder="Enter greeting"
            class="w-full md:w-1/3 px-4 py-3 rounded-xl bg-white shadow-sm border border-gray-200 text-gray-800 placeholder-gray-400 outline-none"
          />
          <button
            @click="addNewGreeting"
            :disabled="!language || !greeting"
            :class="[
              'w-full md:w-1/3 px-6 py-3 rounded-xl font-medium transition-all duration-300',
              (!language || !greeting) 
                ? 'bg-gray-100 cursor-not-allowed text-gray-400'
                : 'bg-blue-500 hover:bg-blue-600 text-white shadow-lg hover:shadow-xl hover:-translate-y-0.5'
            ]"
          >
            Add Greeting
          </button>
        </div>
      </div>

      <div v-if="greetings.length > 0" class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4">
        <GreetingCard
          v-for="(item, index) in greetings"
          :key="index"
          :id="item.id"
          :language="item.language"
          :greeting="item.greeting"
          @delete="deleteGreeting(item.id)"
        />
      </div>
    </div>
  </section>
</template>

<script setup>
import { onBeforeMount, ref } from 'vue'
import { makeApiCall } from '../src/utils/api/makeApiCall.js'
import { trackEvent } from './insights/customInsights.js';
import GreetingCard from './components/GreetingCard.vue';
import { toast } from "vue3-toastify";
import inMemoryGreetings from './data/greetings.js';

const greetings = ref([]);
const hostname = ref('');
const language = ref('');
const greeting = ref('');
const isStatic = import.meta.env.VITE_IS_STATIC === 'true';


onBeforeMount(async () => {
  if (!isStatic) {
    const data = await makeApiCall("GET", "/api/greetings");
    greetings.value = data.greetings.sort((a, b) => b.id - a.id);
    hostname.value = data.hostname;
  } else {
    greetings.value = inMemoryGreetings.sort((a, b) => b.id - a.id);;
  }
});

const addNewGreeting = async () => {
  try {
    const newEntry = { language: language.value, greeting: greeting.value };

    if (isStatic) {
      if (greetings.value.some(item => item.language === language.value)) {
        toast.error("Greeting already exists for this language.");
      } else {
        const newId = greetings.value.length + 1;
        greetings.value.unshift({ ...newEntry, id: newId });
        toast.success("Greeting added successfully to the in-memory list.");
      }
    } else {
      const response = await makeApiCall("POST", "/api/greetings", newEntry);
      if (response?.success) {
        greetings.value.unshift(response.data);
        toast.success("Greeting added successfully to the database.");
      } else {
        handleError(response);
      }
    }

    trackEvent("AddNewGreeting", { language: language.value, greeting: greeting.value });

    language.value = '';
    greeting.value = '';
  } catch (error) {
    console.error('Add greeting failed:', error);
    toast.error("An unexpected error occurred.");
  }
};

const deleteGreeting = async (id) => {
  try {
    const response = isStatic
      ? { success: true } // In-memory deletion is always successful
      : await makeApiCall("DELETE", `/api/greetings/${id}`);

    if (response.success) {
      greetings.value = greetings.value.filter(item => item.id !== id);
      toast.success("Greeting deleted successfully.");
    } else {
      handleError(response);
    }
  } catch (error) {
    console.error("Error deleting greeting:", error);
    toast.error("An unexpected error occurred while deleting the greeting.");
  }
};

const handleError = async (response) => {
  const errorData = await response.json();
  console.error("Error:", errorData.error);
  toast.error(errorData.error || "An unexpected error occurred.");
};
</script>

<style>
.soft-bg {
  background-color: #f8fafc;
  background-image: 
    radial-gradient(circle at 80% 20%, #f7f8ff 0%, transparent 25%),
    radial-gradient(circle at 20% 80%, #d8eaff 0%, transparent 25%);
}

.soft-input {
  transition: all 0.2s ease;
}

.soft-input:focus {
  border-color: #f43f5e;
  box-shadow: 0 0 0 4px rgba(244, 63, 94, 0.1);
  transform: translateY(-1px);
}

@keyframes float {
  0% { transform: translateY(0px); }
  50% { transform: translateY(-5px); }
  100% { transform: translateY(0px); }
}

.hover-float:hover {
  animation: float 2s ease-in-out infinite;
}
</style>
