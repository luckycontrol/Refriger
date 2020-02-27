//
//  FoodInfo.swift
//  refriger
//
//  Created by 조종운 on 2020/02/01.
//  Copyright © 2020 조종운. All rights reserved.
//

import SwiftUI

struct FoodInfo: View {
    
    @ObservedObject var viewDatas: ViewDatas
    let name: String
    let image: String
    @State var price: String = ""
    let productPrice: String
    
    @State var alert: Bool = false
    @State var activeAlert: String = "addAlert"

    init(viewDatas: ViewDatas, name: String, image: String, price: String) {
        self.viewDatas = viewDatas
        self.name = name
        self.image = image
        self._price = State<String>(initialValue: price)
        self.productPrice = price
    }
    
    @State var count: Int = 1
    
    var body: some View {
        
        VStack {
        
            ScrollView(.vertical, showsIndicators: false) {
                
                VStack(alignment: .leading) {
                
                    Image(image)
                        .resizable().frame(height: 320)
                    
                    Text(name)
                        .font(.system(size: 16))
                        .padding(.vertical, 6)
                    
                    HStack {
                    
                        Text("수량 : \(count)개").padding(.bottom, 6)
                        
                        Spacer()
                        
                        if count >= 2 {
                            // 수량 감소 버튼
                            Button(action: {
                                self.count -= 1
                                
                                self.setProductNumbers(
                                    action: "minus",
                                    price: Int(self.price.components(separatedBy: ",").joined())!,
                                    productPrice: Int(self.productPrice.components(separatedBy: ",").joined())!
                                )
                            }) {
                                
                                Image(systemName: "minus")
                                    .frame(width: 25, height: 25)
                                    .foregroundColor(Color("pink"))
                                    .clipShape(Circle())
                                    .border(Color("pink"), width: 2)
                            }
                        }
                        // 수량 증가 버튼
                        Button(action: {
                            self.count += 1
                            
                            self.setProductNumbers(
                                action: "add",
                                price: Int(self.price.components(separatedBy: ",").joined())!,
                                productPrice: Int(self.productPrice.components(separatedBy: ",").joined())!
                            )
                        }) {
                            
                            Image(systemName: "plus")
                                .frame(width: 25, height: 25)
                                .foregroundColor(Color("pink"))
                                .clipShape(Circle())
                                .border(Color("pink"), width: 2)
                        }.padding(.leading, 20)
                    }
    
                }.padding(.top, 20)
                
                HStack {
                    
                    HStack {
                        Text("\(price) 원")
                            .font(.system(size: 24))
                            .foregroundColor(Color("pink"))
                    }
                    Spacer()
                }
                
                
            }.padding(.horizontal)
            
            Spacer()
            
            HStack {
                
                AddCartButton(viewDatas: viewDatas, alert: $alert, activeAlert: $activeAlert, foodName: name, foodCount: String(count), foodPrice: price)

                NavigationLink(destination: SelectList(viewDatas: viewDatas)) {
                    
                    HStack {
                        Text("구매하기")
                            .foregroundColor(Color("pink"))
                    }
                    .frame(width: 150, height: 50)
                    .border(Color("pink"), width: 5)
                }
                .clipShape(RoundedRectangle(cornerRadius: 5))
                
            }
            .padding(.horizontal, 10)
            .padding(.bottom, 20)
            
        }
        .alert(isPresented: $alert) {
            switch activeAlert {
            case "addAlert":
                return Alert(title: Text("장바구니 추가"), message: Text("\(name)이 장바구니에 추가되었습니다."))
                
            default:
                return Alert(title: Text("장바구니 중복"), message: Text("\(name)이 이미 장바구니에 있습니다."))
            }
        }
    }

    
    func setProductNumbers(action: String, price: Int, productPrice: Int) {
            
        var p: Int!
        
        if action == "add" { p = price + productPrice }
        else if action == "minus" { p = price - productPrice}
        
        self.price = String(p)
        
        if self.price.count == 5 {
            
            let i = self.price.index(self.price.startIndex, offsetBy: 2)
            self.price.insert(",", at: i)
        }
        
        else if self.price.count == 6 {
            
            let i = self.price.index(self.price.startIndex, offsetBy: 3)
            self.price.insert(",", at: i)
        }
        
    }
}

struct AddCartButton: View {
    
    @Environment(\.managedObjectContext) var context
    enum ActiveAlert {
        case addAlert, duplicate
    }
    
    @ObservedObject var viewDatas: ViewDatas
    @Binding var alert: Bool
    @Binding var activeAlert: String
    
    let foodName: String
    let foodCount: String
    let foodPrice: String
    
    @FetchRequest(entity: Select.entity(),
                  sortDescriptors: [NSSortDescriptor(keyPath: \Select.id, ascending: false)]
    ) var selectList: FetchedResults<Select>
    
    var body: some View {
        
        Group {
            if self.viewDatas.login {
                Button(action: {
                    if self.checkDuplicate(foodName: self.foodName) {
                        // 장바구니에 이미 해당 식자재가 있으면
                        self.alert.toggle()
                        self.activeAlert = "duplicate"
                    } else {
                        // 장바구니에 해당 식자재가 없으면
                        self.addCart()
                        self.alert.toggle()
                        self.activeAlert = "addAlert"
                    }
                }) {
                    HStack {
                        Text("장바구니 추가")
                            .foregroundColor(.gray)
                    }
                    .frame(width: 150, height: 50)
                    .border(Color.gray, width: 5)
                }.clipShape(RoundedRectangle(cornerRadius: 5))
            } else {
                NavigationLink(destination: SelectList(viewDatas: viewDatas)) {
                    HStack {
                        Text("장바구니 추가")
                            .foregroundColor(.gray)
                    }
                    .frame(width: 150, height: 50)
                    .border(Color.gray, width: 5)
                }
                .clipShape(RoundedRectangle(cornerRadius: 5))
            }
        }
    }
    
    func checkDuplicate(foodName: String) -> Bool {
        // true면 중복 false면 중복 아님
        var duplicate: Bool = false
        
        for c in selectList {
            if c.foodName == foodName {
                duplicate = true
            }
        }
        return duplicate
    }
    
    func addCart() {
        let newCell = Select(context: context)
        
        newCell.id = UUID()
        newCell.foodName = self.foodName
        newCell.foodCount = self.foodCount
        newCell.foodPrice = self.foodPrice
        
        do { try context.save() } catch { print(error) }
    }
}
