import axios from 'axios';

// Use production URL by default, or env variable if set
const API_URL = import.meta.env.VITE_API_URL || 'http://52.213.152.92/api';

const api = axios.create({
    baseURL: API_URL,
    headers: {
        'Content-Type': 'application/json'
    }
});

api.interceptors.request.use(
    (config) => {
        const token = localStorage.getItem('token');
        if (token) {
            config.headers.Authorization = `Bearer ${token}`;
        }
        return config;
    },
    (error) => {
        return Promise.reject(error);
    }
);

export const authAPI = {
    login: (email, password) => api.post('/auth/login', { email, password }),
    register: (data) => api.post('/auth/register', data),
    getMe: () => api.get('/auth/me')
};

export const menuAPI = {
    getAll: (params) => api.get('/menu', { params }),
    getById: (id) => api.get(`/menu/${id}`),
    create: (data) => api.post('/menu', data),
    update: (id, data) => api.put(`/menu/${id}`, data),
    delete: (id) => api.delete(`/menu/${id}`),
    getCategories: () => api.get('/menu/categories')
};

export const billAPI = {
    getAll: (params) => api.get('/bills', { params }),
    getById: (id) => api.get(`/bills/${id}`),
    getByNumber: (billNumber) => api.get(`/bills/number/${billNumber}`),
    getByTableNumber: (tableNumber) => api.get(`/bills/table/${tableNumber}`),
    create: (data) => api.post('/bills', data),
    addItems: (id, data) => api.post(`/bills/${id}/items`, data),
    close: (id) => api.put(`/bills/${id}/close`)
};

export const paymentAPI = {
    process: (data) => api.post('/payments', data),
    getAll: (params) => api.get('/payments', { params })
};

export default api;