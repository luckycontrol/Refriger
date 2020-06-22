var table = document.getElementById('delivered');
var db = firebase.firestore();

db.collection("Delivered").get().then((querySnapshot) => {

    // firestore에서 데이터를 가져온다.
    querySnapshot.forEach((doc) => {
        
        let name = doc.data()["name"].split("-");

        let date = doc.data()["orderdate"].split("-");

        let address = doc.data()["address"].split("|");

        let foodName_list = doc.data()["foodNames"].split("-");

        let hp = doc.data()["hp"].split("-");
        
        for(var i=0; i<name.length; i++) {

            let foodName_div = foodName_list[i].split('|');

            let foodName_str = foodName_div.join('<br>');

            let row = table.insertRow(1);
            row.insertCell(0).innerHTML = name[i];
            row.insertCell(1).innerHTML = date[i];
            row.insertCell(2).innerHTML = address[i];
            row.insertCell(3).innerHTML = foodName_str;
            row.insertCell(4).innerHTML = hp[i];

            let refund = document.createElement('button');
            refund.innerHTML = "환불";
            //refund.setAttribute("id", refund_btn);
            row.insertCell(5).appendChild(refund);
        }
    });
});