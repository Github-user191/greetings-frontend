class EnvConfig {
    constructor() {
      const env = import.meta.env
      this.isStatic = import.meta.env.VITE_IS_STATIC === undefined ? true : import.meta.env.VITE_IS_STATIC === 'true';
      this.serverHostname = env.VITE_SERVER_HOSTNAME 
        ? `https://${env.VITE_SERVER_HOSTNAME}`
        : 'http://localhost:8080'

        console.log(this.serverHostname)
    }
  
    isDevelopment() {
      return import.meta.env.DEV
    }
  
    isProduction() {
      return import.meta.env.PROD
    }
  
    getServerHostname() {
      return this.serverHostname
    }
  
    isStaticSite() {
      return this.isStatic
    }
  }
  
  export const envConfig = new EnvConfig()