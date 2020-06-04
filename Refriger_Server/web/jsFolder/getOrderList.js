var table = document.getElementById('OrderList');
var db = firebase.firestore();
var ordersRef = db.collection("Orders")

var userAccounts = []
var names = []
var dates = []
var addresses = []
var foodNames = []
var hps = []


db.collection("Orders").get().then((querySnapshot) => {

    // firestore에서 데이터를 가져온다.
    querySnapshot.forEach((doc) => {
        
        var name = doc.data()["name"].split("-");
        var date = doc.data()["OrderDate"].split("-");
        var address = doc.data()["Address"].split("-");
        var foodName = doc.data()["foodNames"].split("-");
        var hp = doc.data()["HP"].split("-");

        for(var i=0; i<name.length; i++) {
            userAccounts.push(doc.id);
            names.push(name[i]);
            dates.push(date[i]);
            addresses.push(address[i]);
            foodNames.push(foodName[i].split("|"));
            hps.push(hp[i]);
        }
    });

    // 테이블 Row 만들기
    for(var i=0; i<names.length; i++) {
        let row = table.insertRow(1);
        let f = foodNames[i][0] + "<br>";
        let qr_div_id = "qr_div" + i;
        let ready_btn = "ready_btn_" + i;
        let refund_btn = "refund_btn_" + i;
        
        // 주문리스트 String 생성
        if(foodNames[i].length > 1) {
            for(var j=1; j<foodNames[i].length; j++) {
                f += foodNames[i][j] + "<br>";
            }
        }

        row.insertCell(0).innerHTML = names[i];
        row.insertCell(1).innerHTML = dates[i];
        row.insertCell(2).innerHTML = addresses[i];
        row.insertCell(3).innerHTML = f;
        row.insertCell(4).innerHTML = hps[i];
        row.insertCell(5).innerHTML = '<div id="'+qr_div_id+'">';

        
        makeCode(userAccounts[i], i, qr_div_id);

        var done = document.createElement('button');
        done.innerHTML = "준비완료";
        done.setAttribute("id", ready_btn);
        row.insertCell(6).appendChild(done);

        var refund = document.createElement('button');
        refund.innerHTML = "환불";
        refund.setAttribute("id", refund_btn);
        row.insertCell(7).appendChild(refund);
    }
});

function makeCode(userAccount, index, qr_div_id) {
    let qr_str = "";

    qr_str = userAccount + '/' + index

    new QRCode(qr_div_id, {
        text: qr_str,
        width: 128,
        height: 128,
        colorDark: "#120136",
        colorLight: "#ffffff",
        correctLevel: QRCode.CorrectLevel.L
    });
}