class EnvConfig {
    constructor() {
      this.isStatic = import.meta.env.VITE_IS_STATIC === undefined ? true : import.meta.env.VITE_IS_STATIC === 'true';
      this.apiUrl = import.meta.env.VITE_APP_API_URL || 'http://localhost:8080'
    }
  
    isDevelopment() {
      return import.meta.env.DEV
    }
  
    isProduction() {
      return import.meta.env.PROD
    }
  
    getApiUrl() {
      return this.apiUrl
    }
  
    isStaticSite() {
      return this.isStatic
    }
  }
  
  export const envConfig = new EnvConfig()