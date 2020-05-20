var loginStatus = false; 
  
firebase.auth().onAuthStateChanged((user) => {
    if(user) {
        loginStatus = true
        document.getElementById('login').textContent = "로그아웃";
    } else {
        document.getElementById('login').textContent = "로그인";
    }
})
  
function actLoginState() {
    if (loginStatus) {
        var result = confirm("로그아웃 하시겠습니까?");
        if (result) {
            firebase.auth().signOut().then(() => {
                window.location.href='index.html';
            }, (error) => {
                console.error('Sign Out Error', error);
            });
            
        }
    } else {
        location.href = "login.html";
    }
}

function orderList() {
    if (loginStatus) {
        location.href = "orderList.html";
    } else {
        var result = confirm("관리자만 접속할 수 있습니다. 계정이 있으신가요?");
        if (result) {
            location.href = "login.html";
        }
    }
}
  
function completeList() {
    if (loginStatus) {
        location.href = "ended.html";
    } else {
        var result = confirm("관리자만 접속할 수 있습니다. 계정이 있으신가요?");
        if (result) {
            location.href = "login.html";
        }
    }
}
  
$(document).ready(function(){
    $('#icon').click(function(){
        $('ul').toggleClass('show')
    })
})