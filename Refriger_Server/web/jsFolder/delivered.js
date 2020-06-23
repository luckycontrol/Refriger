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
            row.insertCell(5).innerHTML = '<div id = qr_div' + i + '>';

            makeCode(doc.id, i, 'qr_div'+i)

            let refund = document.createElement('button');
            refund.innerHTML = "환불";
            refund.setAttribute("id", doc.id+'/'+i);
            refund.addEventListener('click', function() {
                product_refund(this.id);
            });
            row.insertCell(6).appendChild(refund);
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

function product_refund(email_index) {
    ref = email_index.split('/');

    db.collection('Delivered').doc(ref[0]).get().then((doc) => {
        let name = doc.data()['name'].split('-');
        let address = doc.data()['address'].split('|');
        let orderdate = doc.data()['orderdate'].split('-');
        let hp = doc.data()['hp'].split('-');
        let foodNames = doc.data()['foodNames'].split('-');
        let foodTypes = doc.data()['foodTypes'].split('-');
        let foodExpirations = doc.data()['foodExpirations'].split('/');

        name.splice(ref[1], 1);
        address.splice(ref[1], 1);
        orderdate.splice(ref[1], 1);
        hp.splice(ref[1], 1),
        foodNames.splice(ref[1], 1);
        foodTypes.splice(ref[1], 1);
        foodExpirations.splice(ref[1], 1);
        
        if(name.length == 0) {
            db.collection('Delivered').doc(ref[0]).delete()
            .then(() => {
                location.reload();
            });
            return;
        }

        db.collection('Delivered').doc(ref[0]).set({
            name: name.join('-').toString(),
            address: address.join('|').toString(),
            hp: hp.join('-').toString(),
            orderdate: orderdate.join('-').toString(),
            foodNames: foodNames.join('-').toString(),
            foodTypes: foodTypes.join('-').toString(),
            foodExpirations: foodExpirations.join('/').toString()
        }).then(() => {
            location.reload();
        });
    });
}