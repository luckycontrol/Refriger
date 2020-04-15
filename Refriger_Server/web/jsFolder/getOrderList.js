firebase.initializeApp({
    apiKey: "AIzaSyBwXDbapXQsdyIja4Yh092VyL-SllQptGA",
    authDomain: "refriger-a735b.firebaseapp.com",
    projectId: "refriger-a735b",
})

var table = document.getElementById('OrderList');
var db = firebase.firestore();
var ordersRef = db.collection("Orders")

db.collection("Orders").get().then((querySnapshot) => {
    querySnapshot.forEach((doc) => {
        var name = doc.data()["name"].split("-");
        window.alert(name[0]);
    });
});