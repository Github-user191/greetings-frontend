import appInsights from './appInsights.js';

const trackEvent = (name, properties = {}) => {
    appInsights.trackEvent({
      name: name,
      properties: {
        ...properties,
        timestamp: new Date().toISOString()
      }
    });
  };

  
  const trackException = (exception, properties = {}) => {
    appInsights.trackException({
        exception: exception,
        properties: {
            ...properties,
            timestamp: new Date().toISOString()
        }
    });
  };


  export { trackException, trackEvent}