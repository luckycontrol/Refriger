//
//  PurchaseView.swift
//  Refriger
//
//  Created by 조종운 on 2020/03/26.
//  Copyright © 2020 조종운. All rights reserved.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

struct PurchaseView: View {
    
    @ObservedObject var viewDatas: ViewDatas
    @State var Select = SelectedList()
    @State var name: String = ""
    @State var HP: String = ""
    @State var address: String = ""
    @Binding var totalPrice: String
    
    let db = Firestore.firestore()
    @State var didGetData: Bool = false
    
    @State var purchase: Bool = false
    @State var purchaseState: purchaseProduct = .purchase
    @State var error: String = ""
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            if didGetData {
                VStack {
                    HStack {
                        Text("식자재 목록")
                            .font(.system(size: 16, weight: .semibold))
                        Spacer()
                    }.padding(.bottom, 10)
                    
                    ForEach(Select.selectedList) { i in
                        VStack {
                            HStack(spacing: 8) {
                                Text(i.foodName).lineLimit(nil)
                                Text("\(i.foodCount) 개")
                                Text("\(i.foodPrice) 원")
                                Spacer()
                            }
                            Divider()
                        }
                    }
                    
                    VStack {
                        HStack {
                            Text("수신자 명")
                                .font(.system(size: 16, weight: .semibold))
                            Spacer()
                        }
                        ZStack {
                            Rectangle()
                                .frame(height: 50)
                                .foregroundColor(.white)
                                .border(Color.gray)
                            
                            TextField(name == "" ? "수신자 명을 입력해주세요." : "\(name)", text: $name)
                                .padding(.leading, 12)
                        }
                    }
                    
                    VStack {
                        HStack {
                            Text("휴대폰 번호")
                                .font(.system(size: 16, weight: .semibold))
                            Spacer()
                        }
                        ZStack {
                            Rectangle()
                                .frame(height: 50)
                                .foregroundColor(.white)
                                .border(Color.gray)
                            
                            TextField(HP == "" ? "'-'를 제외하고 휴대폰 번호를 입력해주세요." : "\(HP)", text: $HP)
                                .padding(.leading, 12)
                        }
                    }.padding(.vertical, 20)
                    
                    VStack {
                        HStack {
                            Text("배송지 주소")
                                .font(.system(size: 16, weight: .semibold))
                            Spacer()
                        }
                        ZStack {
                            Rectangle()
                                .frame(height: 50)
                                .foregroundColor(.white)
                                .border(Color.gray)
                            TextField(address == "" ? "배송지를 입력해주세요." : "\(address)", text: $address)
                                .padding(.leading, 12)
                        }
                    }.padding(.bottom, 20)
                    
                    Text("\(error)").foregroundColor(.red)
                        .padding(.bottom, 20)
                    
                    Text("결제 금액 : \(totalPrice) 원")
                    Button(action: { self.purchase = true }) {
                        ZStack {
                            Capsule()
                                .frame(width: 300, height: 55)
                                .foregroundColor(Color("Color"))
                            
                            Text("결제").foregroundColor(.white)
                        }
                    }.padding(.bottom, 15)
                    
                    
                }
                .padding(.top, 25)
                .padding(.horizontal, 15)
            }
        }
        .onAppear {
            self.getInfo { getData in
                if getData {
                    self.didGetData = true
                }
            }
        }
        .onDisappear {
            self.Select.selectedList = []
        }
        .alert(isPresented: $purchase) {
            switch purchaseState {
            case .purchase:
                return alert
                
            case .purchased:
                return purchased
            }
        }
    }
    
    var alert: Alert {
        Alert(
            title: Text("결제하시겠습니까?"),
            primaryButton: .default(Text("결제")) {
                self.checkUserInfo()
            },
            secondaryButton: .default(Text("취소"))
        )
    }
    
    var purchased: Alert {
        Alert(
            title: Text("결제완료"),
            message: Text("성공적으로 구매되었습니다."),
            dismissButton: .default(Text("확인")) {
                // 뷰 이동
            }
        )
    }
    
    func getInfo(completion: @escaping (Bool) -> Void) {
        db.collection("users").document(viewDatas.email).getDocument { (document, error) in
            let foodNames = String(describing: document!.data()!["foodName"]!).components(separatedBy: "|")
            let foodCounts = String(describing: document!.data()!["foodCount"]!).components(separatedBy: "|")
            let foodPrices = String(describing: document!.data()!["foodPrice"]!).components(separatedBy: "|")
            self.HP = String(describing: document!.data()!["HP"]!)
            self.address = String(describing: document!.data()!["address"]!)
            
            for i in 0 ..< foodNames.count {
                self.Select.selectedList.append(
                    SelectedType(
                        foodName: foodNames[i],
                        foodCount: foodCounts[i],
                        foodPrice: foodPrices[i]
                    )
                )
            }
            self.name = self.viewDatas.name
            completion(true)
        }
    }
    
    func checkUserInfo() {
        if self.HP == "" {
            error = "휴대폰 번호를 입력해주세요."
            return
        }
        
        if HP.count != 11 {
            error = "휴대폰 번호 형식이 올바르지 않습니다."
            return
        }
        
        if self.address == "" {
            error = "배송지를 입력해주세요."
            return
        }
        
        purchaseProducts()
    }
    
    // firebase Orders에 새로운 주문을 생성
    func purchaseProducts() {
        // 새로 구입할 음식이름, 갯수
        var foodNames: String = ""
        var foodCounts: String = ""
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        
        for i in Select.selectedList {
            foodNames += i.foodName + "|"
            foodCounts += i.foodCount + "|"
        }
        foodNames.removeLast()
        foodCounts.removeLast()
        
        // 기존에 주문한 내역 가져옴
        getOrdered { (orderedNames, orderedFoodNames, orderedHP, orderDate, orderAddress, foodType, getData, isData) in
            if getData {
                // 사용자가 이전에 구매를 한 내역이 있는 경우
                if isData {
                    
                    self.db.collection("Orders").document(self.viewDatas.email).setData([
                        "name" : orderedNames + "-" + self.name,
                        "foodNames" : orderedFoodNames + "-" + foodNames,
                        "HP" : orderedHP + "-" + self.HP,
                        "Address" : orderAddress + "|" + self.address,
                        "OrderDate" : orderDate + "-" + formatter.string(from: Date())
                        
                    ])
                // 첫 구매인 경우
                } else {
                    self.db.collection("Orders").document(self.viewDatas.email).setData([
                        "name" : self.viewDatas.name,
                        "foodNames" : foodNames,
                        "HP" : orderedHP + "-" + self.HP,
                        "OrderDate" : formatter.string(from: Date()),
                        "Address" : self.address,
                        
                    ])
                }
                // 사용자 장바구니 초기화
                self.db.collection("users").document(self.viewDatas.email).setData([
                    "foodName" : "",
                    "foodCount" : "",
                    "foodPrice" : "",
                    "HP" : self.HP,
                    "address" : self.address,
                    "foodType" : ""
                ], merge: true)
            }
        }
        self.purchaseState = .purchased
        self.purchase = true
    }
    
    // 사용자의 구매내역을 가져온다. + Orders에 doc이 있는지 확인
    func getOrdered(completion: @escaping (String, String, String, String, String, String, Bool, Bool) -> Void) {
        db.collection("Orders").document(viewDatas.email).getDocument { (document, error) in
            if let document = document, document.exists {
                let orderedNames = String(describing: document.data()!["name"]!)
                let orderedFoodNames = String(describing: document.data()!["foodNames"]!)
                let orderDate = String(describing: document.data()!["OrderDate"]!)
                let orderAddress = String(describing: document.data()!["Address"]!)
                let orderedHP = String(describing: document.data()!["HP"]!)
                let foodType = String(describing: document.data()!["foodType"]!)
                
                completion(orderedNames, orderedFoodNames, orderedHP, orderDate, orderAddress, foodType, true, true)
            } else {
                completion("", "", "", "", "", "", true, false)
            }
        }
    }
    
}

enum purchaseProduct {
    case purchase, purchased
}
