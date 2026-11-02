# ลิงก์ถาวรสำหรับ staging

ลิงก์บน GitHub Pages ที่ไม่เปลี่ยน แม้ลิงก์ Cloudflare (trycloudflare.com) จะเปลี่ยนทุกครั้งที่เปิดระบบใหม่

| ลิงก์ถาวร | ส่งต่อไปที่ |
|---|---|
| https://ohayouohayouohayou.github.io/pcs/weather/ | เว็บตรวจสภาพอากาศ (`D:\xampp1010\wether\staging\start-staging.cmd`) |
| https://ohayouohayouohayou.github.io/pcs/cctv/ | ระบบ CCTV (`D:\pooc\staging\start-staging.cmd`) ต่อท้าย `#k=รหัส` เพื่อเข้าโดยไม่ต้องกรอกรหัส |

- `targets.json` เก็บลิงก์ trycloudflare ล่าสุดของแต่ละระบบ สคริปต์ของทั้ง 2 ระบบเรียก `update-link.ps1` เพื่ออัปเดตไฟล์นี้และ push ขึ้น GitHub ให้เอง หน้า `cctv/` และ `weather/` อ่านไฟล์นี้แล้วพาไปที่ลิงก์นั้น
- repo นี้เป็นสาธารณะ ข้างในมีแค่ลิงก์ trycloudflare **ไม่มีรหัสผ่าน** ส่วนหลัง `#` ของลิงก์ CCTV เบราว์เซอร์ไม่ส่งไปที่ GitHub
- หลังเปิดระบบใหม่ GitHub ใช้เวลาประมาณ 1 นาทีกว่าลิงก์ถาวรจะพาไปที่ใหม่
- ถ้าเครื่องปิดอยู่ ลิงก์ถาวรจะพาไปหน้า error ของ Cloudflare
