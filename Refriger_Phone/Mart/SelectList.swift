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
    
    @FetchRequest(entity: Select.entity(),
                  sortDescriptors: [NSSortDescriptor(keyPath: \Select.id, ascending: false)]
    ) var selectList: FetchedResults<Select>
    
    @Environment(\.managedObjectContext) var context
    
    let db = Firestore.firestore().collection("users")
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
                    if selectList.count > 0 {
                        ScrollView(.vertical, showsIndicators: false) {
                            HStack {
                                Text("\(viewDatas.name) 님의 장바구니 내역입니다.")
                                .font(.system(size: 22, weight: .semibold))
                                .padding([.top, .bottom], 20)
                                Spacer()
                            }
                            
                            ForEach(selectList) { c in
                                VStack {
                                    HStack(spacing: 14) {
                                        Text("\(c.foodName!)")
                                        Text("\(c.foodCount!)개")
                                        Text("\(c.foodPrice!)원")
                                        Spacer()
                                        if self.edit {
                                            Button(action: {
                                                self.setMinusPrice(foodPrice: Int((c.foodPrice?.components(separatedBy: ",").joined())!)!)
                                                
                                            }) {
                                                Text("삭제").foregroundColor(.red).fontWeight(.semibold)
                                            }
                                        }
                                    }
                                    Divider().padding(.horizontal, 10)
                                }
                            }
                        }.padding(.horizontal, 10)
                        
                        Text(totalPrice)
                        
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
                            self.totalPrice = self.getTotalPrice(foodPrices: foodPrices)
                        }
                    }
                }
            }
            
            else {
                IsNotLogin(viewDatas: viewDatas)
            }
        }
        
    }
    
    func getSelectionList(completion: @escaping ([String], [String], [String], Bool) -> Void) {
        db.document(viewDatas.email).getDocument{ (document, error) in
            self.foodNames = String(describing: document!.data()!["foodName"]!).components(separatedBy: "|")
            self.foodCounts = String(describing: document!.data()!["foodCount"]!).components(separatedBy: "|")
            self.foodPrices = String(describing: document!.data()!["foodPrice"]!).components(separatedBy: "|")
            completion(self.foodNames, self.foodCounts, self.foodPrices, true)
        }
    }
    
    func getTotalPrice(foodPrices: [String]) -> String {
        var sum: Int = 0
        var sum_str: String = ""
        
        for price in foodPrices {
            sum = sum + Int(price.components(separatedBy: ",").joined())!
        }
        
        sum_str = String(sum)
        if sum_str.count == 7 {
            let i = sum_str.index(sum_str.startIndex, offsetBy: 4)
            sum_str.insert(",", at: i)
        }
        if sum_str.count == 6 {
            let i = sum_str.index(sum_str.startIndex, offsetBy: 3)
            sum_str.insert(",", at: i)
        }
        if sum_str.count == 5 {
            let i = sum_str.index(sum_str.startIndex, offsetBy: 2)
            sum_str.insert(",", at: i)
        }
        if sum_str.count == 4 {
            let i = sum_str.index(sum_str.startIndex, offsetBy: 1)
            sum_str.insert(",", at: i)
        }
        
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

