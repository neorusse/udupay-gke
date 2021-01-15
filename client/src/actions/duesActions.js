import axios from 'axios';
import { LOAD_DUES, DUES_ERRORS } from './actionTypes';

/**
 * Load dues
 */
export const loadDues = () => async dispatch => {
  try {
    const res = await axios.get(
      'http://localhost:3050/api/v1/dues/getAllDues',
    );

    dispatch({
      type: LOAD_DUES,
      payload: res.data,
    });
  } catch (err) {
    dispatch({
      type: DUES_ERRORS,
    });
  }
};
