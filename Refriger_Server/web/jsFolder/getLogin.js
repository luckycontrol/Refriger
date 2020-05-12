var loginStatus = false; 
  
function setLoginStatus() {
    firebase.auth().onAuthStateChanged(function(user) {
        if(user) {
            loginStatus = true
            document.getElementById('login').textContent = "로그아웃";
        } else {
            document.getElementById('login').textContent = "로그인";
        }
    })
}
  
function actLoginState() {
    if (loginStatus) {
        var result = confirm("로그아웃 하시겠습니까?");
        if (result) {
            firebase.auth().signOut()
            .then(function() {
                loginStatus = false
            }, function(error) {
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
  
window.onload = function() {
    setLoginStatus();
}
  
$(document).ready(function(){
    $('#icon').click(function(){
        $('ul').toggleClass('show')
    })
})