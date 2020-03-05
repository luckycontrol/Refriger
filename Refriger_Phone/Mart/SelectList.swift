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
                        if foodDatas.foodName.count > 0 {
                            VStack {
                                HStack {
                                    Text("\(viewDatas.name) 님의 장바구니 내역입니다.")
                                        .font(.system(size: 24, weight: .bold))
                                    Spacer()
                                }.padding([.vertical, .leading], 15)
                                ScrollView(.vertical, showsIndicators: false) {
                                    ForEach(0 ... foodDatas.foodName.count - 1, id: \.self) { i in
                                        VStack(spacing: 15) {
                                            HStack {
                                                Text("\(self.foodDatas.foodName[i])")
                                                Text("\(self.foodDatas.foodCount[i]) 개")
                                                Text("\(self.foodDatas.foodPrice[i]) 원")
                                                Spacer()
                                                // 삭제 뷰 작성 - 일정량 드래그시 프린트
                                            }
                                            Divider()
                                        }
                                        .padding([.top, .horizontal], 15)
                                    }
                                }
                                
                                Spacer()
                                
                                Text("총 결제금액 : \(totalPrice) 원")
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
                        } else {
                            VStack {
                                Text("장바구니 내역이 비었습니다!")
                                    .font(.system(size: 22, weight: .bold))
                            }
                            .navigationBarTitle("장바구니 목록", displayMode: .inline)
                        }
                    }
                }
                .onAppear {
                    self.getSelectionList { getData in
                        if getData {
                            self.showSelectionList = true
                            self.totalPrice = self.getTotalPrice()
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
            
            if self.foodDatas.foodName[0] == "" {
                self.foodDatas.foodName.remove(at: 0)
                self.foodDatas.foodCount.remove(at: 0)
                self.foodDatas.foodPrice.remove(at: 0)
            }
            
            completion(true)
        }
    }
    
    func getTotalPrice() -> String {
        var sum: Int = 0
        var sum_str: String = ""
        
        if foodDatas.foodName.count == 0 {
            return "0"
        }
        for i in 0 ..< foodDatas.foodPrice.count {
            sum = sum + Int(foodDatas.foodPrice[i].components(separatedBy: ",").joined())!
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
        
        return sum_str
    }
    
    func removeSelection(index: Int) {
        foodDatas.foodName.remove(at: index)
        foodDatas.foodCount.remove(at: index)
        foodDatas.foodPrice.remove(at: index)
        
        let foodNames: String = foodDatas.foodName.joined(separator: "|")
        let foodCounts: String = foodDatas.foodCount.joined(separator: "|")
        let foodPrices: String = foodDatas.foodPrice.joined(separator: "|")
        
        db.document(viewDatas.email).setData([
            "foodName" : foodNames,
            "foodCount" : foodCounts,
            "foodPrice" : foodPrices,
        ], merge: true)
    }
    
}

class FoodDatas: ObservableObject {
    @Published var foodName: [String] = []
    @Published var foodCount: [String] = []
    @Published var foodPrice: [String] = []
}
