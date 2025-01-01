import { ApplicationInsights } from '@microsoft/applicationinsights-web';


const appInsights = new ApplicationInsights({
  config: {
    connectionString: import.meta.env.VITE_APPLICATIONINSIGHTS_CONNECTION_STRING || 'InstrumentationKey=null',
    enableAutoRouteTracking: true,
  }
});

console.log("app insights config", appInsights.config)

appInsights.loadAppInsights();
appInsights.trackPageView();

export default appInsights;




