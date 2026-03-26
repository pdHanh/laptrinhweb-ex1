// Xử lý form đăng nhập
const loginForm = document.getElementById('loginForm');
if (loginForm) {
    loginForm.addEventListener('submit', function(e) {
        e.preventDefault();
        const username = document.getElementById('username').value;
        const password = document.getElementById('password').value;
        if (username && password) {
            alert(`Đăng nhập thành công! Chào ${username}`);
            // Có thể chuyển hướng sang update.html
            // window.location.href = "update.html";
        } else {
            alert('Vui lòng nhập đầy đủ username và mật khẩu');
        }
    });
}

// Xử lý form đăng ký
const registerForm = document.getElementById('registerForm');
if (registerForm) {
    registerForm.addEventListener('submit', function(e) {
        e.preventDefault();
        const password = document.getElementById('reg_password').value;
        const confirm = document.getElementById('confirm_password').value;
        if (password !== confirm) {
            alert('Mật khẩu xác nhận không khớp');
            return;
        }
        alert('Đăng ký thành công!');
        // Chuyển hướng sang login
        // window.location.href = "login.html";
    });
}

// Xử lý form cập nhật
const updateForm = document.getElementById('updateForm');
if (updateForm) {
    updateForm.addEventListener('submit', function(e) {
        e.preventDefault();
        const oldPw = document.getElementById('old_password').value;
        const newPw = document.getElementById('new_password').value;
        const confirmNew = document.getElementById('confirm_new_password').value;
        if (newPw && newPw !== confirmNew) {
            alert('Mật khẩu mới xác nhận không khớp');
            return;
        }
        alert('Cập nhật thành công!');
    });
}