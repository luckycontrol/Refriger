//
//  SelectList.swift
//  refriger
//
//  Created by 조종운 on 2020/01/31.
//  Copyright © 2020 조종운. All rights reserved.
//

// 장바구니 리스트
import SwiftUI
import Firebase
import FirebaseFirestoreSwift

struct SelectList: View {
    
    @ObservedObject var viewDatas: ViewDatas
    
    @State var minusPrice: Int = 0
    
    let db = Firestore.firestore().collection("users")
    @State var foodDatas: FoodDatas = FoodDatas()
    @State var showSelectionList: Bool = false
    
    // 총 결제금액 수정필요 - foodPrices를 통해서 게산
    @State var edit: Bool = false
    @State var totalPrice: String = ""
    
    var body: some View {
        
        Group {
            if viewDatas.login {
                ZStack {
                    if showSelectionList {
                        VStack {
                            HStack {
                                Text("\(viewDatas.name) 님의 장바구니 내역입니다.")
                                    .font(.system(size: 24, weight: .bold))
                                Spacer()
                            }.padding([.vertical, .leading], 15)
                            ForEach(0 ... foodDatas.foodName.count - 1, id: \.self) { i in
                                VStack(spacing: 15) {
                                    HStack {
                                        Text("\(self.foodDatas.foodName[i])")
                                        Text("\(self.foodDatas.foodCount[i]) 개")
                                        Text("\(self.foodDatas.foodPrice[i]) 원")
                                        Spacer()
                                        if self.edit {
                                            Button(action: {}) {
                                                Text("삭제").foregroundColor(.red)
                                            }
                                        }
                                    }
                                    Divider()
                                }
                                .padding([.top, .horizontal], 15)
                            }
                            
                            Spacer()
                            
                            Text("총 결제금액 : ")
                            Button(action: {}) {
                                ZStack {
                                    Capsule()
                                        .frame(width: 300, height: 55)
                                        .foregroundColor(Color("Color"))
                                    
                                    Text("구매하기")
                                        .foregroundColor(.white)
                                }
                            }.padding(.bottom, 15)
                        }
                        .navigationBarTitle("장바구니 목록", displayMode: .inline)
                    }
                }
                .onAppear {
                    self.getSelectionList { getData in
                        if getData {
                            self.showSelectionList = true
                        }
                    }
                }
            } else {
                IsNotLogin(viewDatas: viewDatas)
            }
        }
        
    }
    
    func getSelectionList(completion: @escaping (Bool) -> Void) {
        db.document(viewDatas.email).getDocument{ (document, error) in
            self.foodDatas.foodName = String(describing: document!.data()!["foodName"]!).components(separatedBy: "|")
            self.foodDatas.foodCount = String(describing: document!.data()!["foodCount"]!).components(separatedBy: "|")
            self.foodDatas.foodPrice = String(describing: document!.data()!["foodPrice"]!).components(separatedBy: "|")
            
            self.foodDatas.foodName.remove(at: 0)
            self.foodDatas.foodCount.remove(at: 0)
            self.foodDatas.foodPrice.remove(at: 0)
            
            completion(true)
        }
    }
    
    func getTotalPrice(foodDatas: FoodDatas) -> String {
        var foodPrices: [String] = []
        var sum: Int = 0
        var sum_str: String = ""
        
        /*
        for p in foodDatas {
            
        }
        */
        /*
        for i in 0 ... foodPrices.count - 1 {
            sum = sum + Int(foodPrices[i].components(separatedBy: ",").joined())!
        }
        
        sum_str = String(sum)
        let c = sum_str.count
        let i = sum_str.index(sum_str.startIndex, offsetBy: c - 3)
        
        if c == 7 {
            sum_str.insert(",", at: sum_str.index(sum_str.startIndex, offsetBy: 1))
            sum_str.insert(",", at: i)
        } else {
            sum_str.insert(",", at: i)
        }
        */
        return sum_str
    }
    
    func setMinusPrice(foodPrice: Int) {
        self.minusPrice = self.minusPrice - foodPrice
    }
    
}

struct SelectRightView: View {
    
    @Binding var edit: Bool
    
    var body: some View {
        Button(action: { withAnimation { self.edit.toggle() } }) {
            Text(edit ? "수정완료" : "목록수정")
        }
    }
}

class FoodDatas: ObservableObject {
    @Published var foodName: [String] = []
    @Published var foodCount: [String] = []
    @Published var foodPrice: [String] = []
}
