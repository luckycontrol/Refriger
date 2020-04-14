var loginStatus = false;
  
function setLoginStatus() {
    var queryString = location.search.substring(1);
    if (queryString === "true") {
        loginStatus = true
    } else {
        loginStatus = false
    }
  
    if (loginStatus) { document.getElementById('login').textContent = "로그아웃"; }
    else { document.getElementById('login').textContent = "로그인"; }
}
  
function actLoginState() {
    if (loginStatus) {
        var result = confirm("로그아웃 하시겠습니까?");
        if (result) {
            location.href = "index.html";
        }
    } else {
        location.href = "login.html";
    }
}
  
function main() {
    if (loginStatus) {
        location.href = "index.html?true"
    } else {
        location.href = "index.html?false"
    }
}
  
function orderList() {
    if (loginStatus) {
        location.href = "orderList.html?true";
    } else {
        var result = confirm("관리자만 접속할 수 있습니다. 계정이 있으신가요?");
        if (result) {
            location.href = "login.html";
        }
    }
}
  
function completeList() {
    if (loginStatus) {
        location.href = "ended.html?true";
    } else {
        var result = confirm("관리자만 접속할 수 있습니다. 계정이 있으신가요?");
        if (result) {
            location.href = "login.html";
        }
    }
}
  
function introSite() {
    if (loginStatus) {
        location.href = "introSite.html?true"
    } else {
        location.href = "introSite.html?false"
    }
}
  
function introEditor() {
    if (loginStatus) {
        location.href = "introEditor.html?true"
    } else {
        location.href = "introEditor.html?false"
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