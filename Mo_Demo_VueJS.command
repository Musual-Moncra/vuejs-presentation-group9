#!/bin/bash
cd "/Users/musual/(Môn Học) Web Front-end/ThuyetTrinh_VueJS_Nhom9/demo-vuejs" || exit 1
echo "Đang khởi động server Demo VueJS..."
(sleep 2 && open "http://localhost:5173") &
npm run dev
