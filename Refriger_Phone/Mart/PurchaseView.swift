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
    @Binding var Select: SelectedList
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
                                Text(i.foodName)
                                Text("\(i.foodCount) 개")
                                Text("\(i.foodPrice) 원")
                                Spacer()
                            }
                            Divider()
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
                    
                    Text("결제 금액 : \(totalPrice)")
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
            self.HP = String(describing: document!.data()!["HP"]!)
            self.address = String(describing: document!.data()!["address"]!)
            
            completion(true)
        }
    }
    
    func checkUserInfo() {
        let hp = self.HP.components(separatedBy: "-")
        if self.HP == "" {
            error = "휴대폰 번호를 입력해주세요."
            return
        }
        
        if hp.count != 11 {
            error = "휴대폰 번호 형식이 올바르지 않습니다."
            return
        }
        
        if self.address == "" {
            error = "배송지를 입력해주세요."
            return
        }
        
        purchaseProducts()
    }
    
    func purchaseProducts() {
        var foodNames: String = ""
        var foodCounts: String = ""
        
        for i in Select.selectedList {
            foodNames += i.foodName + "|"
            foodCounts += i.foodCount + "|"
        }
        foodNames.removeLast()
        foodCounts.removeLast()
        
        self.db.collection("Orders").document(viewDatas.name).setData([
            "foodNames" : foodNames,
            "foodCounts" : foodCounts,
            "totalPrice" : totalPrice,
        ])
        
        self.db.collection("users").document(viewDatas.name).setData([
            "foodName" : "",
            "foodPrice" : "",
            "foodCount" : "",
            "HP" : self.HP,
            "address" : self.address,
        ], merge: true)
        
        self.purchaseState = .purchased
        self.purchase = true
    }
}

enum purchaseProduct {
    case purchase, purchased
}
