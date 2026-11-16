<script setup>
// Nhận danh sách đã lọc từ App.vue thông qua Props
defineProps({
  products: {
    type: Array,
    required: true,
  },
});

// Gửi sự kiện Sửa / Xóa lên App.vue thông qua Emits
defineEmits(['edit', 'remove']);

function formatCurrency(value) {
  return Number(value).toLocaleString('vi-VN') + ' đ';
}
</script>

<template>
  <div v-if="products.length === 0" class="text-center text-muted py-5">
    Không có sản phẩm nào phù hợp với từ khóa hoặc bộ lọc hiện tại.
  </div>

  <div v-else class="table-responsive">
    <table class="table table-hover align-middle mb-0">
      <thead class="table-light small">
        <tr>
          <th>ID</th>
          <th>Tên sản phẩm</th>
          <th>Danh mục</th>
          <th>Giá bán</th>
          <th>Trạng thái</th>
          <th class="text-end">Thao tác</th>
        </tr>
      </thead>
      <tbody>
        <!-- v-for: lặp từng phần tử và dùng :key để Virtual DOM cập nhật tối ưu -->
        <tr v-for="item in products" :key="item.id">
          <td class="text-muted">#{{ item.id }}</td>
          <td class="fw-semibold">{{ item.name }}</td>
          <td>
            <span class="badge bg-light text-dark border">{{ item.category }}</span>
          </td>
          <td>{{ formatCurrency(item.price) }}</td>
          <td>
            <!-- :class động thể hiện trạng thái bằng màu sắc -->
            <span
              class="status-dot"
              :class="item.stock > 0 ? 'bg-success' : 'bg-danger'"
            ></span>
            <span class="small" :class="item.stock > 0 ? 'text-success' : 'text-danger fw-semibold'">
              {{ item.stock > 0 ? `Còn (${item.stock})` : 'Hết hàng' }}
            </span>
          </td>
          <td class="text-end">
            <button
              class="btn btn-sm btn-outline-primary me-1"
              @click="$emit('edit', item)"
            >
              Sửa
            </button>
            <button
              class="btn btn-sm btn-outline-danger"
              @click="$emit('remove', item.id)"
            >
              Xóa
            </button>
          </td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<style scoped>
.status-dot {
  width: 10px;
  height: 10px;
  border-radius: 50%;
  display: inline-block;
  margin-right: 6px;
}
</style>
