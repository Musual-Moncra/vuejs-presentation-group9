<script setup>
import { ref, watch } from 'vue';

// Nhận dữ liệu sản phẩm đang chọn sửa từ component cha (App.vue)
const props = defineProps({
  editingProduct: {
    type: Object,
    default: null,
  },
});

// Khai báo các sự kiện gửi ngược lên component cha
const emit = defineEmits(['save', 'cancel']);

const name = ref('');
const category = ref('Laptop');
const price = ref(1500000);
const stock = ref(10);
const errorMessage = ref('');

// Theo dõi khi người dùng bấm "Sửa" một sản phẩm khác -> tự đổ dữ liệu vào form
watch(
  () => props.editingProduct,
  (item) => {
    errorMessage.value = '';
    if (item) {
      name.value = item.name;
      category.value = item.category;
      price.value = item.price;
      stock.value = item.stock;
    } else {
      resetFields();
    }
  },
);

function resetFields() {
  name.value = '';
  category.value = 'Laptop';
  price.value = 1500000;
  stock.value = 10;
}

function handleSubmit() {
  errorMessage.value = '';
  if (!name.value.trim() || name.value.trim().length < 2) {
    errorMessage.value = 'Tên sản phẩm phải có ít nhất 2 ký tự.';
    return;
  }
  if (!Number.isFinite(Number(price.value)) || Number(price.value) < 1000) {
    errorMessage.value = 'Giá bán phải từ 1.000 VNĐ trở lên.';
    return;
  }
  if (!Number.isFinite(Number(stock.value)) || Number(stock.value) < 0) {
    errorMessage.value = 'Số lượng tồn kho không được âm.';
    return;
  }

  emit('save', {
    id: props.editingProduct ? props.editingProduct.id : null,
    name: name.value.trim(),
    category: category.value,
    price: Number(price.value),
    stock: Number(stock.value),
  });

  if (!props.editingProduct) {
    resetFields();
  }
}
</script>

<template>
  <div class="card border-0 shadow-sm rounded-4 p-4">
    <h5 class="fw-bold mb-3">
      {{ editingProduct ? `Cập nhật sản phẩm #${editingProduct.id}` : 'Thêm sản phẩm mới' }}
    </h5>

    <!-- v-if: chỉ hiện khung báo lỗi khi errorMessage có nội dung -->
    <div v-if="errorMessage" class="alert alert-danger py-2 small">
      {{ errorMessage }}
    </div>

    <form @submit.prevent="handleSubmit">
      <div class="mb-3">
        <label class="form-label small fw-semibold">Tên sản phẩm (v-model)</label>
        <input
          v-model="name"
          type="text"
          class="form-control"
          placeholder="VD: Chuột Logitech G Pro"
        />
      </div>

      <div class="mb-3">
        <label class="form-label small fw-semibold">Danh mục</label>
        <select v-model="category" class="form-select">
          <option value="Laptop">Laptop</option>
          <option value="Phụ kiện">Phụ kiện</option>
          <option value="Màn hình">Màn hình</option>
          <option value="Âm thanh">Âm thanh</option>
        </select>
      </div>

      <div class="row g-2 mb-3">
        <div class="col">
          <label class="form-label small fw-semibold">Giá bán (VNĐ)</label>
          <input v-model.number="price" type="number" class="form-control" />
        </div>
        <div class="col">
          <label class="form-label small fw-semibold">Tồn kho</label>
          <input v-model.number="stock" type="number" class="form-control" />
        </div>
      </div>

      <div class="d-grid gap-2">
        <button type="submit" class="btn btn-vue fw-semibold">
          {{ editingProduct ? 'Lưu cập nhật' : 'Thêm vào danh sách' }}
        </button>
        <button
          v-if="editingProduct"
          type="button"
          class="btn btn-outline-secondary btn-sm"
          @click="$emit('cancel')"
        >
          Hủy chỉnh sửa
        </button>
      </div>
    </form>
  </div>
</template>

<style scoped>
.btn-vue {
  background-color: #42b883;
  color: #ffffff;
  border: none;
}
.btn-vue:hover {
  background-color: #359469;
  color: #ffffff;
}
</style>
