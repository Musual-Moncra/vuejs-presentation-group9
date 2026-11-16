<script setup>
import { computed, ref } from 'vue';
import ProductForm from './components/ProductForm.vue';
import ProductList from './components/ProductList.vue';

// State reactive chính của ứng dụng
const products = ref([
  { id: 1, name: 'Laptop MacBook Air M3', category: 'Laptop', price: 26900000, stock: 8 },
  { id: 2, name: 'Bàn phím cơ Keychron K2 Pro', category: 'Phụ kiện', price: 2150000, stock: 15 },
  { id: 3, name: 'Màn hình Dell UltraSharp 27"', category: 'Màn hình', price: 11500000, stock: 0 },
  { id: 4, name: 'Tai nghe Sony WH-1000XM5', category: 'Âm thanh', price: 6890000, stock: 5 },
]);

const nextId = ref(5);
const searchQuery = ref('');
const selectedCategory = ref('ALL');
const editingProduct = ref(null);

// Computed: tự động tính toán lại khi products, searchQuery hoặc selectedCategory thay đổi
const filteredProducts = computed(() => {
  const kw = searchQuery.value.trim().toLowerCase();
  return products.value.filter((item) => {
    const matchCategory =
      selectedCategory.value === 'ALL' || item.category === selectedCategory.value;
    const matchSearch =
      !kw ||
      item.name.toLowerCase().includes(kw) ||
      item.category.toLowerCase().includes(kw);
    return matchCategory && matchSearch;
  });
});

const inStockCount = computed(
  () => products.value.filter((item) => item.stock > 0).length,
);

const outOfStockCount = computed(
  () => products.value.filter((item) => item.stock === 0).length,
);

function handleSaveProduct(payload) {
  if (payload.id) {
    const idx = products.value.findIndex((p) => p.id === payload.id);
    if (idx !== -1) {
      products.value[idx] = { ...payload };
    }
    editingProduct.value = null;
  } else {
    products.value.unshift({
      id: nextId.value++,
      name: payload.name,
      category: payload.category,
      price: payload.price,
      stock: payload.stock,
    });
  }
}

function handleStartEdit(item) {
  editingProduct.value = { ...item };
}

function handleRemoveProduct(id) {
  products.value = products.value.filter((p) => p.id !== id);
  if (editingProduct.value && editingProduct.value.id === id) {
    editingProduct.value = null;
  }
}
</script>

<template>
  <nav class="navbar navbar-dark bg-dark mb-4">
    <div class="container">
      <span class="navbar-brand fw-bold">
        <span class="badge vue-badge me-2">Vue 3</span> Demo Quản lý Sản phẩm
      </span>
      <span class="text-light small opacity-75">Composition API + Vite + Bootstrap</span>
    </div>
  </nav>

  <div class="container pb-5">
    <div class="alert alert-light border d-flex flex-wrap justify-content-between align-items-center mb-4">
      <div>
        <strong>Nhóm 9 — SW306DV01:</strong> Trương Đức Trí · Lưu Nguyễn Quốc Tân · Nguyễn Công Minh · Dư Tấn Quang
      </div>
      <div class="d-flex gap-3 small">
        <span>Tổng: <strong>{{ products.length }}</strong></span>
        <span class="text-success">Còn hàng: <strong>{{ inStockCount }}</strong></span>
        <span class="text-danger">Hết hàng: <strong>{{ outOfStockCount }}</strong></span>
      </div>
    </div>

    <div class="row g-4">
      <div class="col-lg-4">
        <ProductForm
          :editing-product="editingProduct"
          @save="handleSaveProduct"
          @cancel="editingProduct = null"
        />
      </div>

      <div class="col-lg-8">
        <div class="card border-0 shadow-sm rounded-4 p-4">
          <div class="d-flex flex-wrap justify-content-between align-items-center gap-2 mb-3">
            <h5 class="fw-bold mb-0">
              Danh sách sản phẩm ({{ filteredProducts.length }})
            </h5>
            <div class="d-flex gap-2">
              <input
                v-model="searchQuery"
                type="text"
                class="form-control form-control-sm"
                placeholder="Tìm kiếm live (v-model)..."
                style="width: 210px"
              />
              <select
                v-model="selectedCategory"
                class="form-select form-select-sm"
                style="width: 140px"
              >
                <option value="ALL">Tất cả</option>
                <option value="Laptop">Laptop</option>
                <option value="Phụ kiện">Phụ kiện</option>
                <option value="Màn hình">Màn hình</option>
                <option value="Âm thanh">Âm thanh</option>
              </select>
            </div>
          </div>

          <ProductList
            :products="filteredProducts"
            @edit="handleStartEdit"
            @remove="handleRemoveProduct"
          />
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.vue-badge {
  background-color: #42b883;
  color: #ffffff;
}
</style>
