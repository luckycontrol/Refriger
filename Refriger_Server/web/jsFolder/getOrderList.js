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

    for(var i=0; i<names.length; i++) {
        var row = table.insertRow(1);
        var f = foodNames[i][0] + "<br>";

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
        row.insertCell(5).innerHTML = "qr코드";

        var done = document.createElement('button');
        done.innerHTML = "준비완료";
        done.setAttribute("class", "Order_ready");
        row.insertCell(6).appendChild(done);

        var refund = document.createElement('button');
        refund.innerHTML = "환불";
        refund.setAttribute("class", "Order_refund");
        row.insertCell(7).appendChild(refund);
    }
});