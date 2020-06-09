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
        
        let name = doc.data()["name"].split("-");

        let date = doc.data()["OrderDate"].split("-");

        let address = doc.data()["Address"].split("|");

        let foodName_list = doc.data()["foodNames"].split("-");

        let hp = doc.data()["HP"].split("-");
        
        for(var i=0; i<name.length; i++) {

            let foodName_div = foodName_list[i].split('|');

            let foodName_str = foodName_div.join('<br>');

            let row = table.insertRow(1);
            row.insertCell(0).innerHTML = name[i];
            row.insertCell(1).innerHTML = date[i];
            row.insertCell(2).innerHTML = address[i];
            row.insertCell(3).innerHTML = foodName_str;
            row.insertCell(4).innerHTML = hp[i];
            row.insertCell(5).innerHTML = '<div id = qr_div' + i + '>';

            makeCode(doc.id, i, "qr_div"+i);

            let done = document.createElement('button');
            done.innerHTML = "준비완료";
            //done.setAttribute("id", ready_btn);
            row.insertCell(6).appendChild(done);

            let refund = document.createElement('button');
            refund.innerHTML = "환불";
            //refund.setAttribute("id", refund_btn);
            row.insertCell(7).appendChild(refund);
        }
    });
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