<template>
  <div class="greeting-card" @click="handleGreetingClick(language, greeting)">
    <div class="card-content">
      <h2 class="language">{{ language }}</h2>
      <p class="greeting">{{ greeting }}</p>
    </div>
  </div>
</template>

<script setup>
import {trackEvent} from '../insights/customInsights';


defineProps({
    language: String,
    greeting: String
})

const handleGreetingClick = (language, greeting) => {
    trackEvent("GreetingClicked", {
        language: language,
        greeting: greeting
    })
}


</script>

<style scoped>
.greeting-card {
    background: linear-gradient(135deg, #6e7fdb, #8a6fff);
    color: #ffffff;
    padding: 2rem;
    border-radius: 20px;
    text-align: center;
    box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2);
    transition: transform 0.3s ease, box-shadow 0.3s ease, background 0.3s ease;
    cursor: pointer;
    overflow: hidden;
}

.greeting-card:hover {
    transform: translateY(-15px);
    box-shadow: 0 15px 30px rgba(0, 0, 0, 0.3);
    background: linear-gradient(135deg, #8a6fff, #6e7fdb);
}

.card-content {
    display: flex;
    flex-direction: column;
    justify-content: center;
}

.language {
    font-size: 1.8rem;
    font-weight: 700;
    letter-spacing: 1px;
    text-transform: uppercase;
    margin-bottom: 1rem;
    animation: fadeIn 0.8s ease-out;
}

.greeting {
    font-size: 1.4rem;
    font-weight: 500;
    color: #f0f4fc;
    animation: fadeIn 1s ease-out;
}

@keyframes fadeIn {
    0% {
        opacity: 0;
        transform: translateY(10px);
    }

    100% {
        opacity: 1;
        transform: translateY(0);
    }
}
</style>
