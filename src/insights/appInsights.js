import { ApplicationInsights } from '@microsoft/applicationinsights-web';


const appInsights = new ApplicationInsights({
  config: {
    connectionString: import.meta.env.VITE_APPLICATIONINSIGHTS_CONNECTION_STRING || 'InstrumentationKey=null',
    enableAutoRouteTracking: true,
  }
});

appInsights.loadAppInsights();
appInsights.trackPageView();

export default appInsights;




