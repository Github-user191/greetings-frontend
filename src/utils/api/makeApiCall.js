import axios from "axios";
import { trackEvent, trackException} from '../../insights/customInsights.js';
import { envConfig } from "./envConfig.js";


const makeApiCall = async (method, path, data = null, config = {}) => {

  const url = `${envConfig.getServerHostname()}/${path}`;
  console.log(url)
    try {
      const response = await axios({
        method,
        url, 
        data,
        ...config
      });
      
      trackEvent('apiSuccess', {
        url,
        method,
        statusCode: response.status,
        response: response.data
      });
      
      return response.data; 
    } catch (error) {

      trackException('apiFailure', {
        url,
        method,
        requestData: JSON.stringify(data),
        error: error
      });

      console.error(`Error: ${error}`);
    }
};


export {
  makeApiCall
}