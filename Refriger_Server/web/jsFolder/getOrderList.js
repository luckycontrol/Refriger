var table = document.getElementById('OrderList');
var db = firebase.firestore();

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
            done.setAttribute("id", doc.id+'/'+i);
            done.addEventListener("click", function() {
                setOrderList(this.id);
            });
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

function setOrderList(email_index) {

    // ref 0 - 이메일, ref 1 - 인덱스
    ref = email_index.split('/');

    db.collection('Orders').doc(ref[0]).get().then((doc) => {
        if (doc.exists) {
            let foodNames = doc.data()['foodNames'].split('-');
            let foodExpirations = doc.data()['foodExpirations'].split('/');
            let foodTypes = doc.data()['foodTypes'].split('-')
            let address = doc.data()['Address'].split('|');
            let hp = doc.data()['HP'].split('-');
            let name = doc.data()['name'].split('-');
            let orderDate = doc.data()['OrderDate'].split('-');

            // 인덱스 부분 지우기
            let delivered_food = foodNames.splice(ref[1], 1);
            foodExpirations.splice(ref[1], 1);
            foodTypes.splice(ref[1], 1);
            let delivered_address = address.splice(ref[1], 1)
            let delivered_hp = hp.splice(ref[1], 1);
            let delivered_name = name.splice(ref[1], 1);
            let delivered_orderdate = orderDate.splice(ref[1], 1);

            // 문서에 남은 주문이 없다면 문서를 삭제
            if (foodNames.length == 0) {
                db.collection('Orders').doc(ref[0]).delete();
                return;
            }

            // 남은 주문들을 연결
            foodNames = foodNames.join('-');
            foodExpirations = foodExpirations.join('/');
            foodTypes = foodTypes.join('-');
            address = address.join('|');
            hp = hp.join('-');
            name = name.join('-');
            orderDate = orderDate.join('-');

            // 계정 문서에 변경된 주문내역을 저장 
            db.collection('Orders').doc(ref[0]).set({
                foodNames: foodNames.toString(),
                foodExpirations: foodExpirations.toString(),
                foodTypes: foodTypes.toString(),
                Address: address.toString(),
                HP: hp.toString(),
                name: name.toString(),
                OrderDate: orderDate.toString()

            }).then(() => {
                // Delivered의 해당 독에서 주문을 가져와서 주문을 수정 후 저장
                db.collection('Delivered').doc(ref[0]).get().then((doc) => {
                    if (doc.exists) {
                        // 문서가 있으면 주문을 가져와서 수정 후 저장
                        let d_name = doc.data()['name'].split('-');
                        let d_address = doc.data()['address'].split('|');
                        let d_hp = doc.data()['hp'].split('-');
                        let d_orderdate = doc.data()['orderdate'].split('-');
                        let d_foodNames = doc.data()['foodNames'].split('-');

                        d_name.push(delivered_name);
                        d_address.push(delivered_address);
                        d_hp.push(delivered_hp);
                        d_orderdate.push(delivered_orderdate);
                        d_foodNames.push(delivered_food);

                        db.collection('Delivered').doc(ref[0]).set({
                            name: d_name.join('-').toString(),
                            address: d_address.join('|').toString(),
                            hp: d_hp.join('-').toString(),
                            orderdate: d_orderdate.join('-').toString(),
                            foodNames: d_foodNames.join('-').toString()
                        });
                    } else {
                        // 문서가 없으면 그냥 저장
                        db.collection('Delivered').doc(ref[0]).set({
                            name: delivered_name.toString(),
                            address: delivered_address.toString(),
                            hp: delivered_hp.toString(),
                            orderdate: delivered_orderdate.toString(),
                            foodNames: delivered_food.toString()
                        });
                    }
                });
            });
        }
    });
}