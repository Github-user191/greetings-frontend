<template>
  <section class="greetings-page">
    <div class="greetings-container">
      <h1 class="greetings-title">Welcome to the Greetings App!</h1>
      <p class="greetings-description">Explore greetings from different cultures and languages.</p>
      <div class="greetings-grid" v-if="greetings?.length>0">
        <GreetingCard
          v-for="(item, index) in greetings"
          :key="index"
          :language="item.Language"
          :greeting="item.Greeting"
        />
      </div>
    </div>
  </section>
</template>

<script setup>
import { onBeforeMount, ref } from 'vue'
import GreetingCard from './components/GreetingCard.vue'
import { makeApiCall } from '../src/utils/api/makeApiCall.js'
import { trackEvent} from './insights/customInsights.js';
import { envConfig } from './utils/api/envConfig.js';

const greetings = ref([]);


onBeforeMount(async () => {

  console.log('Current Mode:', import.meta.env.MODE)
  console.log('ENV', import.meta.env)
  console.log(envConfig.isStaticSite())


  if(!envConfig.isStaticSite()) {
    greetings.value = await makeApiCall("GET", `api/greetings`);
  } else {

    greetings.value = [
      { Id: 1, Language: "English", Greeting: "Hello" },
      { Id: 2, Language: "Spanish", Greeting: "Hola" },
      { Id: 3, Language: "French", Greeting: "Bonjour" },
      { Id: 4, Language: "German", Greeting: "Hallo" },
      { Id: 5, Language: "Italian", Greeting: "Ciao" },
      { Id: 6, Language: "Japanese", Greeting: "こんにちは" },
      { Id: 7, Language: "Chinese", Greeting: "你好" },
      { Id: 8, Language: "Hindi", Greeting: "नमस्ते" },
      { Id: 9, Language: "Russian", Greeting: "Привет" },
      { Id: 10, Language: "Portuguese", Greeting: "Olá" },
      { Id: 11, Language: "Arabic", Greeting: "أهلاً" },
      { Id: 12, Language: "Korean", Greeting: "안녕하세요" },
      { Id: 13, Language: "Dutch", Greeting: "Hallo" },
      { Id: 14, Language: "Swedish", Greeting: "Hej" },
      { Id: 15, Language: "Turkish", Greeting: "Merhaba" }
    ];

    
    trackEvent('MakeInMemoryCall', {
      response: greetings.value
    });

  }
  
})


</script>

<style scoped>
.greetings-page {
  background: #f4f7fc;
  color: #333;
  font-family: 'Poppins', sans-serif;
  min-height: 100vh;
  display: flex;
  justify-content: center;
  align-items: center;
}

.greetings-container {
  text-align: center;
  padding: 3rem;
}

.greetings-title {
  font-size: 3.5rem;
  font-weight: 600;
  margin-bottom: 1rem;
  color: #1a202c;
}

.greetings-description {
  font-size: 1.2rem;
  font-weight: 300;
  color: #4a5568;
  margin-bottom: 2rem;
}

.greetings-grid {
  margin-top: 5rem;
  display: grid;
  gap: 2rem;
  grid-template-columns: repeat(auto-fit, minmax(270px, 1fr));
}
</style>
