import axios from 'axios';

const API_URL = import.meta.env.VITE_API_URL || 'http://localhost:5000';

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
    login: (email, password) => api.post('/api/auth/login', { email, password }),
    register: (data) => api.post('/api/auth/register', data),
    getMe: () => api.get('/api/auth/me')
};

export const menuAPI = {
    getAll: (params) => api.get('/api/menu', { params }),
    getById: (id) => api.get(`/api/menu/${id}`),
    create: (data) => api.post('/api/menu', data),
    update: (id, data) => api.put(`/api/menu/${id}`, data),
    delete: (id) => api.delete(`/api/menu/${id}`),
    getCategories: () => api.get('/api/menu/categories')
};

export const billAPI = {
    getAll: (params) => api.get('/api/bills', { params }),
    getById: (id) => api.get(`/api/bills/${id}`),
    getByNumber: (billNumber) => api.get(`/api/bills/number/${billNumber}`),
    getByTableNumber: (tableNumber) => api.get(`/api/bills/table/${tableNumber}`),
    create: (data) => api.post('/api/bills', data),
    addItems: (id, data) => api.post(`/api/bills/${id}/items`, data),
    close: (id) => api.put(`/api/bills/${id}/close`)
};

export const paymentAPI = {
    process: (data) => api.post('/api/payments', data),
    getAll: (params) => api.get('/api/payments', { params })
};

export default api;