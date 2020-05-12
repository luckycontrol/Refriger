firebase.initializeApp({
    apiKey: "AIzaSyBwXDbapXQsdyIja4Yh092VyL-SllQptGA",
    authDomain: "refriger-a735b.firebaseapp.com",
    projectId: "refriger-a735b",
})

var table = document.getElementById('OrderList');
var db = firebase.firestore();
var ordersRef = db.collection("Orders")

var names = []
var dates = []
var addresses = []
var foodNames = []
var foodCounts = []
var hps = []

db.collection("Orders").get().then((querySnapshot) => {

    // firestore에서 데이터를 가져온다.
    querySnapshot.forEach((doc) => {
        var name = doc.data()["name"].split("-");
        var date = doc.data()["OrderDate"].split("-");
        var address = doc.data()["Address"].split("-");
        var foodName = doc.data()["foodNames"].split("-");
        var foodCount = doc.data()["foodCounts"].split("-");
        var hp = doc.data()["HP"].split("-");

        for(var i=0; i<name.length; i++) {
            names.push(name[i]);
            dates.push(date[i]);
            addresses.push(address[i]);
            foodNames.push(foodName[i].split("|"));
            foodCounts.push(foodCount[i]);
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

        makeCode(i, qr_div_id);

        var done = document.createElement('button');
        done.innerHTML = "준비완료";
        done.setAttribute("id", ready_btn);
        done.addEventListener('click', retrnID(this.id));
        row.insertCell(6).appendChild(done);

        var refund = document.createElement('button');
        refund.innerHTML = "환불";
        refund.setAttribute("id", refund_btn);
        refund.addEventListener("click", () => {

        });
        row.insertCell(7).appendChild(refund);
    }
});

function retrnID(clicked_id) {
    alert(clicked_id);
}

function makeCode(index, id) {
    let qr_foodNames = "";

    for(let i=0; i<foodNames[index].length; i++) {
        qr_foodNames += foodNames[index][i] + ",";
    }
    qr_foodNames = qr_foodNames.slice(0, qr_foodNames.length - 1);

    new QRCode(id, {
        text: qr_foodNames,
        width: 128,
        height: 128,
        colorDark: "#120136",
        colorLight: "#ffffff",
        correctLevel: QRCode.CorrectLevel.L
    });
}