function signIn() {
    var email = document.getElementById('email').value;
    var password = document.getElementById('password').value;

    if (email.length < 4) {
      alert("이메일 형식이 올바르지 않습니다.");
      return;
    }
    if (password.length < 4) {
      alert("비밀번호 형식이 올바르지 않습니다.");
      return;
    }

    firebase.auth().signInWithEmailAndPassword(email, password)
      .then(function(firebaseUser) {
        loginSuccess(firebaseUser);
      })
      .catch(function(error) {
        var errCode = error.code;
        var errMessage = error.message;

        alert(errcode);
        /*
        if (errCode === 'auth/wrong-password') {
          alert("비밀번호가 올바르지 않습니다.");
        }
        */
      })
  }

  function loginSuccess(firebaseUser) {
    location.href="/index.html?true";
  }

  function orderList() {
    alert("권한이 없습니다. 로그인을 먼저 해주세요.");
  }

  function completeList() {
    alert("권한이 없습니다. 로그인을 먼저 해주세요.");
  } 

  $(document).ready(function(){
      $('#icon').click(function(){
        $('ul').toggleClass('show')
      })
  })