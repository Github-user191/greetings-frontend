import axios from 'axios';
import { trackEvent, trackException } from '../../insights/customInsights.js';

const apiUrl = import.meta.env.VITE_APP_API_URL || ''; // Load API URL from environment variables

// Utility function to make API calls
const makeApiCall = async (method, path, data = null, config = {}) => {
  try {

    const url = apiUrl ? `${apiUrl}${path}` : path;
    console.log('Making API call to:', url);

    // We are using NGINX in prod to proxy API calls through /api to the backend service, no need to pass in the prod hostname
    const response = await axios({
      method,
      // For App Service, we need to preprend the App Service URL to the path
      // For the dockerized apps we don't need to prepend the API URL since we are using NGINX to proxy the API calls through /api to the backend service
      baseURL: apiUrl ?? undefined,
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
