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
    
    // 사용자의 장바구니목록을 firestore에서 가져옴
    var selectionList: [String : Any] {
        let db = Firestore.firestore().collection("selectionList")
        db.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error : \(err)")
            } else {
                for document in querySnapshot!.documents {
                    if String(describing: document.data()["userName"]!) == self.viewDatas.name {
                        let d = document.data()
                        return d
                    }
                }
            }
        }
    }
    
    var totalPrice: Int {
        var p: Int = 0
        for c in selectList {
            p = p + Int((c.foodPrice?.components(separatedBy: ",").joined())!)!
        }
        return p
    }
    
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
                                                self.removeSelected(cell: c)
                                            }) {
                                                Text("삭제").foregroundColor(.red).fontWeight(.semibold)
                                            }
                                        }
                                    }
                                    Divider().padding(.horizontal, 10)
                                }
                            }
                        }.padding(.horizontal, 10)
                        
                        TotalPrice(totalPrice: totalPrice, minusPrice: $minusPrice)
                        
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
            }
            
            else {
                IsNotLogin(viewDatas: viewDatas)
            }
        }
        
    }
    
    func setMinusPrice(foodPrice: Int) {
        self.minusPrice = self.minusPrice - foodPrice
    }
    
    func removeSelected(cell: Select) {
        self.context.delete(cell)
        
        do{
            try context.save()
        }catch { print(error) }
    }
}

struct TotalPrice: View {
    
    @State var totalPrice: Int
    
    @Binding var minusPrice: Int
    
    var body: some View {
        Text("총 결제금액 : \(totalPrice - minusPrice)")
            .font(.system(size: 20, weight: .semibold))
            .multilineTextAlignment(.leading)
            .padding([.leading, .top], 15)
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

