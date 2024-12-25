import axios from 'axios';
import { trackEvent, trackException } from '../../insights/customInsights.js';

// Utility function to make API calls
const makeApiCall = async (method, path, data = null, config = {}) => {
  try {
    console.log('Making API call to:', path);

    // We are using NGINX in prod to proxy API calls through /api to the backend service, no need to pass in the prod hostname
    const response = await axios({
      method,
      baseURL: '/api', // Proxy API calls through Nginx at /api
      url: path, // Relative path to the API endpoint
      data,
      ...config,
    });

    trackEvent('apiSuccess', {
      url: path,
      method,
      statusCode: response.status,
      response: response.data,
    });

    return response.data;
  } catch (error) {
    trackException('apiFailure', {
      url: path,
      method,
      requestData: JSON.stringify(data),
      error: error.message || error,
    });

    console.error('API call error:', error.message || error);
    throw error; 
  }
};

export { makeApiCall };
