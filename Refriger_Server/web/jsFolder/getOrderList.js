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

            let done = document.createElement('button');
            done.innerHTML = "준비완료";
            done.setAttribute("id", doc.id+'/'+i);
            done.addEventListener("click", function() {
                setOrderList(this.id);
            });
            row.insertCell(5).appendChild(done);

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

            // 회원의 주문이 하나밖에 없을 때
            if(foodNames.length < 2) {
                db.collection("Orders").doc(ref[0]).delete();

                db.collection('Delivered').doc(ref[0]).get().then((doc) => {
                    if (doc.exists) {
                        // 이미 주문한 내역이 있는 경우
                        let d_name = doc.data()['name'].split('-');
                        let d_address = doc.data()['address'].split('|');
                        let d_hp = doc.data()['hp'].split('-');
                        let d_orderdate = doc.data()['orderdate'].split('-');
                        let d_foodNames = doc.data()['foodNames'].split('-');
                        let d_foodTypes = doc.data()['foodTypes'].split('-');
                        let d_foodExpirations = doc.data()['foodExpirations'].split('/');

                        d_name.push(name);
                        d_address.push(address);
                        d_hp.push(hp);
                        d_orderdate.push(orderDate);
                        d_foodNames.push(foodNames);
                        d_foodTypes.push(foodTypes);
                        d_foodExpirations.push(foodExpirations);
    
                        db.collection('Delivered').doc(ref[0]).set({
                            name: d_name.join('-').toString(),
                            address: d_address.join('|').toString(),
                            hp: d_hp.join('-').toString(),
                            orderdate: d_orderdate.join('-').toString(),
                            foodNames: d_foodNames.join('-').toString(),
                            foodTypes: d_foodTypes.join('-').toString(),
                            foodExpirations: d_foodExpirations.join('/').toString()
                        }).then(() => {
                            location.reload();
                        });
                    } else {
                        // 첫 주문인 경우
                        db.collection('Delivered').doc(ref[0]).set({
                            name: name.toString(),
                            address: address.toString(),
                            hp: hp.toString(),
                            orderdate: orderDate.toString(),
                            foodNames: foodNames.toString(),
                            foodTypes: foodTypes.toString(),
                            foodExpirations: foodExpirations.toString()
                        }).then(() => {
                            location.reload();
                        });
                    }
                });
                
            // 주문이 2개 이상일 때
            } else {
                let deliver_foodName = foodNames.splice(ref[1], 1);
                let deliver_foodExpiration = foodExpirations.splice(ref[1], 1);
                let deliver_foodType = foodTypes.splice(ref[1], 1);
                let deliver_address = address.splice(ref[1], 1)
                let deliver_hp = hp.splice(ref[1], 1);
                let deliver_name = name.splice(ref[1], 1);
                let deliver_orderdate = orderDate.splice(ref[1], 1);
                
                if(foodNames.length > 1) {
                    foodNames = foodNames.join('-');
                    foodExpirations = foodExpirations.join('/');
                    foodTypes = foodTypes.join('-');
                    address = address.join('|');
                    hp = hp.join('-');
                    name = name.join('-');
                    orderDate = orderDate.join('-');
                }

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
                            // 주문 내역이 있는 경우
                            let d_name = doc.data()['name'].split('-');
                            let d_address = doc.data()['address'].split('|');
                            let d_hp = doc.data()['hp'].split('-');
                            let d_orderdate = doc.data()['orderdate'].split('-');
                            let d_foodNames = doc.data()['foodNames'].split('-');
                            let d_foodTypes = doc.data()['foodTypes'].split('-');
                            let d_foodExpirations = doc.data()['foodExpirations'].split('/');
    
                            d_name.push(deliver_name);
                            d_address.push(deliver_address);
                            d_hp.push(deliver_hp);
                            d_orderdate.push(deliver_orderdate);
                            d_foodNames.push(deliver_foodName);
                            d_foodTypes.push(deliver_foodType);
                            d_foodExpirations.push(deliver_foodExpiration);
        
                            db.collection('Delivered').doc(ref[0]).set({
                                name: d_name.join('-').toString(),
                                address: d_address.join('|').toString(),
                                hp: d_hp.join('-').toString(),
                                orderdate: d_orderdate.join('-').toString(),
                                foodNames: d_foodNames.join('-').toString(),
                                foodTypes: d_foodTypes.join('-').toString(),
                                foodExpirations: d_foodExpirations.join('/').toString()
                            }).then(() => {
                                location.reload();
                            });
                        } else {
                            // 첫 주문인 경우
                            db.collection('Delivered').doc(ref[0]).set({
                                name: deliver_name.toString(),
                                address: deliver_address.toString(),
                                hp: deliver_hp.toString(),
                                orderdate: deliver_orderdate.toString(),
                                foodNames: deliver_foodName.toString(),
                                foodTypes: deliver_foodType.toString(),
                                foodExpirations: deliver_foodExpiration.toString()
                            }).then(() => {
                                location.reload();
                            });
                        }
                    });
                });
            }
        }
    });
}

function product_refund(email_index) {
    ref = email_index.split('/');

    db.collection('Orders').doc(ref[0]).get().then((doc) => {
        let name = doc.data()['name'].split('-');
        let address = doc.data()['Address'].split('|');
        let orderdate = doc.data()['OrderDate'].split('-');
        let hp = doc.data()['HP'].split('-');
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
            db.collection('Orders').doc(ref[0]).delete()
            .then(() => {
                location.reload();
            });
            return;
        }

        db.collection('Orders').doc(ref[0]).set({
            name: name.join('-').toString(),
            Address: address.join('|').toString(),
            HP: hp.join('-').toString(),
            OrderDate: orderdate.join('-').toString(),
            foodNames: foodNames.join('-').toString(),
            foodTypes: foodTypes.join('-').toString(),
            foodExpirations: foodExpirations.join('/').toString()
        }).then(() => {
            location.reload();
        });
    });
}