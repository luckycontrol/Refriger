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
    
    let db = Firestore.firestore()
    @State var Select = SelectedList()
    @State var showSelectionList: Bool = false
    
    // 총 결제금액 수정필요 - foodPrices를 통해서 게산
    @State var edit: Bool = false
    @State var totalPrice: String = ""
    @State var purchase: Bool = false
    
    var body: some View {
        
        Group {
            if viewDatas.login {
                ZStack {
                    if showSelectionList {
                        if self.Select.selectedList.count > 0 {
                            VStack {
                                HStack {
                                    Text("\(viewDatas.name)")
                                        .font(.system(size: 24, weight: .bold))
                                        .foregroundColor(Color("Color-1"))
                                    Text(" 님의 장바구니 내역입니다.")
                                        .font(.system(size: 20, weight: .semibold))
                                    Spacer()
                                }.padding([.vertical, .leading], 15)
                                ScrollView(.vertical, showsIndicators: false) {
                                    ForEach(self.Select.selectedList) { i in
                                        VStack {
                                            HStack {
                                                Image(i.foodName)
                                                    .resizable()
                                                    .frame(width: 60, height: 60)
                                                VStack(alignment: .leading){
                                                    HStack(spacing: 20){
                                                        Text("\(i.foodName) \(i.foodCount) 개")
                                                            .lineLimit(nil)
                                                    }
                                                    Text("\(i.foodPrice) 원")
                                                }
                                                Spacer()
                                                if self.edit {
                                                    Button(action: { self.removeSeletedFood(name: i.foodName) }) {
                                                        Text("삭제")
                                                            .foregroundColor(.red)
                                                    }
                                                }
                                            }
                                            .fixedSize(horizontal: false, vertical: true)
                                            Divider()
                                        }
                                        .padding([.top, .horizontal], 15)
                                    }
                                }
                                
                                Spacer()
                                
                                Text("총 결제금액 : \(totalPrice) 원")
                                NavigationLink(destination: PurchaseView(viewDatas: viewDatas,Select: $Select, totalPrice: $totalPrice)) {
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
                            .navigationBarItems(trailing: SelectedSideBar(edit: $edit))
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
                .onDisappear {
                    self.Select.selectedList = []
                }
            } else {
                IsNotLogin(viewDatas: viewDatas)
            }
        }
    }
    
    func getSelectionList(completion: @escaping (Bool) -> Void) {
        db.collection("users").document(viewDatas.email).getDocument{ (document, error) in
            let foodNames = String(describing: document!.data()!["foodName"]!).components(separatedBy: "|")
            let foodCounts = String(describing: document!.data()!["foodCount"]!).components(separatedBy: "|")
            let foodPrices = String(describing: document!.data()!["foodPrice"]!).components(separatedBy: "|")
            
            for i in 0 ..< foodNames.count {
                self.Select.selectedList.append(
                    SelectedType(
                        foodName: foodNames[i],
                        foodCount: foodCounts[i],
                        foodPrice: foodPrices[i]
                    )
                )
            }
            
            if self.Select.selectedList[0].foodName == "" {
                self.Select.selectedList.remove(at: 0)
            }
            
            completion(true)
        }
    }
    // 최종 금액 계산
    func getTotalPrice() -> String {
        var sum: Int = 0
        var sum_str: String = ""
        
        if self.Select.selectedList.count == 0 {
            return "0"
        }
        for s in self.Select.selectedList {
            sum = sum + Int(s.foodPrice.components(separatedBy: ",").joined())!
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
    // 음식 지우기
    func removeSeletedFood(name: String) {
        var foodNames: String = ""
        var foodCounts: String = ""
        var foodPrices: String = ""
        for i in 0 ..< Select.selectedList.count {
            if Select.selectedList[i].foodName == name {
                Select.selectedList.remove(at: i)
                break
            }
        }
        
        for i in 0 ..< Select.selectedList.count {
            foodNames = foodNames + "|" + Select.selectedList[i].foodName
            foodCounts = foodCounts + "|" + Select.selectedList[i].foodCount
            foodPrices = foodPrices + "|" + Select.selectedList[i].foodPrice
        }
        
        db.collection("users").document(viewDatas.email).setData([
            "foodName" : foodNames,
            "foodCount" : foodCounts,
            "foodPrice" : foodPrices,
        ], merge: true)
    }
}

struct SelectedSideBar: View {
    @Binding var edit: Bool
    var body: some View {
        Button(action: {
            withAnimation{
                self.edit.toggle()
            }
        }) {
            Text("목록수정")
        }
    }
}

class SelectedList: ObservableObject{
    @Published var selectedList = [SelectedType]()
}

struct SelectedType: Identifiable {
    var id = UUID()
    var foodName: String
    var foodCount: String
    var foodPrice: String
}
