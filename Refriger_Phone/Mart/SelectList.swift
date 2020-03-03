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
    
    @State var edit: Bool = false
    
    @State var minusPrice: Int = 0
    
    let db = Firestore.firestore().collection("users")
    @State var foodDatas: FoodDatas = FoodDatas()
    @State var foodNames: [String] = []
    @State var foodCounts: [String] = []
    @State var foodPrices: [String] = []
    
    // 총 결제금액 수정필요 - foodPrices를 통해서 게산
    @State var totalPrice: String = ""
    
    var body: some View {
        
        Group {
            if viewDatas.login {
                VStack {
                    // 장바구니에 추가한 내역이 있을 때
                    if foodNames.count > 0 {
                        ScrollView(.vertical, showsIndicators: false) {
                            HStack {
                                Text("\(viewDatas.name) 님의 장바구니 내역입니다.")
                                .font(.system(size: 22, weight: .semibold))
                                .padding([.top, .bottom], 20)
                                Spacer()
                            }
                            /*
                            ForEach(0 ... foodNames.count, id: \.self) { i in
                                VStack {
                                    HStack(spacing: 14) {
                                        Text("\(self.foodDatas.foodName[i])")
                                        Text("\(self.foodDatas.foodCount[i])개")
                                        Text("\(self.foodDatas.foodPrice[i])원")
                                        Spacer()
                                        if self.edit {
                                            /*
                                            Button(action: {
                                                self.setMinusPrice(foodPrice: Int((c.foodPrice.components(separatedBy: ",").joined())!)!)
                                                
                                            }) {
                                                Text("삭제").foregroundColor(.red).fontWeight(.semibold)
                                            }
                                            */
                                        }
                                    }
                                    Divider().padding(.horizontal, 10)
                                }
                            }
                            */
                            
                        }.padding(.horizontal, 10)
                        
                        Text("총 결제금액 : \(totalPrice)")
                        
                        // 결제 버튼
                        Spacer()
                        Button(action: {}) {
                            HStack {
                                Text("결제").foregroundColor(.white).fontWeight(.semibold)
                            }
                            .frame(width: 250, height: 50)
                            .background(Color("Color"))
                            .clipShape(Capsule())
                        }.padding(.bottom, 15)
                        
                        // 장바구니에 추가한 것이 아무것도 없을 때
                    } else {
                        VStack(spacing: 8) {
                            Text("장바구니 내역이 없습니다.")
                                .font(.system(size: 23, weight: .bold))
                            Text("원하시는 식품들로 장비구니를 채워보세요!")
                                .font(.system(size: 22, weight: .bold))
                                .multilineTextAlignment(.center)
                        }
                    }
                }
                .navigationBarTitle("장바구니 목록")
                .navigationBarItems(trailing: SelectRightView(edit: $edit))
                .onAppear {
                    self.getSelectionList { foodNames, foodCounts, foodPrices, getData in
                        if getData {
                            // totalPrice 계산
                            self.totalPrice = self.getTotalPrice(foodDatas: self.foodDatas)
                        }
                    }
                    print(self.foodNames)
                }
            } else {
                IsNotLogin(viewDatas: viewDatas)
            }
        }
        
    }
    
    func getSelectionList(completion: @escaping ([String], [String], [String], Bool) -> Void) {
        db.document(viewDatas.email).getDocument{ (document, error) in
            self.foodNames = String(describing: document!.data()!["foodName"]!).components(separatedBy: "|")
            self.foodCounts = String(describing: document!.data()!["foodCount"]!).components(separatedBy: "|")
            self.foodPrices = String(describing: document!.data()!["foodPrice"]!).components(separatedBy: "|")
            
            self.foodNames.remove(at: 0)
            self.foodCounts.remove(at: 0)
            self.foodPrices.remove(at: 0)
            
            completion(self.foodNames, self.foodCounts, self.foodPrices, true)
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

