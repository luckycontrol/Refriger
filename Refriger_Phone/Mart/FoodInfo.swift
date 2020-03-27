//
//  FoodInfo.swift
//  refriger
//
//  Created by 조종운 on 2020/02/01.
//  Copyright © 2020 조종운. All rights reserved.
//

import SwiftUI
import FirebaseFirestore
import Firebase

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
                        .font(.system(size: 20, weight: .semibold))
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
                                ZStack {
                                    RoundedRectangle(cornerRadius: 5)
                                        .foregroundColor(.white)
                                        .frame(width: 25, height: 25)
                                        .shadow(color: .gray, radius: 0.5, x: -1, y: 1)
                                    
                                    Image(systemName: "minus")
                                }
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
                            ZStack {
                                RoundedRectangle(cornerRadius: 5)
                                    .foregroundColor(.white)
                                    .frame(width: 25, height: 25)
                                    .shadow(color: .gray, radius: 0.5, x: -1, y: 1)
                                
                                Image(systemName: "plus")
                            }
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

                ZStack {
                    RoundedRectangle(cornerRadius: 5)
                        .foregroundColor(.white)
                        .frame(width: 150, height: 50)
                        .shadow(color: .gray, radius: 2, x: 1, y: 1)
                        .shadow(color: .white, radius: 2, x: -1, y: -1)
                    
                    NavigationLink(destination: SelectList(viewDatas: viewDatas)) {
                        Text("구매하기")
                    }
                }
                
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
    
    enum ActiveAlert {
        case addAlert, duplicate
    }
    
    @ObservedObject var viewDatas: ViewDatas
    @Binding var alert: Bool
    @Binding var activeAlert: String
    
    let foodName: String
    let foodCount: String
    let foodPrice: String
    
    @State var foodNames: [String]! = []
    @State var foodCounts: [String]! = []
    @State var foodPrices: [String]! = []
    
    let db = Firestore.firestore().collection("users")
    
    var body: some View {
        
        Group {
            if self.viewDatas.login {
                Button(action: {
                    self.getSelectList { (foodNames, foodCounts, foodPrices, getData) in
                        if getData {
                            if self.checkDuplicate(foodNames: foodNames) {
                                self.alert.toggle()
                                self.activeAlert = "duplicate"
                            } else {
                                self.alert.toggle()
                                self.addCart()
                                self.activeAlert = "addAlert"
                            }
                        }
                    }
                }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 5)
                            .foregroundColor(.white)
                            .frame(width: 150, height: 50)
                            .shadow(color: .gray, radius: 2, x: 1, y: 1)
                            .shadow(color: .white, radius: 2, x: -1, y: -1)
                        
                        Text("장바구니 추가")
                    }
                }
            } else {
                ZStack {
                    RoundedRectangle(cornerRadius: 5)
                        .foregroundColor(.white)
                        .frame(width: 150, height: 50)
                        .shadow(color: .gray, radius: 2, x: 1, y: 1)
                        .shadow(color: .white, radius: 2, x: -1, y: -1)
                    
                    NavigationLink(destination: SelectList(viewDatas: viewDatas)) {
                        Text("장바구니 추가")
                    }
                }
            }
        }
    }
    
    func getSelectList(completion: @escaping ([String], [String], [String], Bool) -> Void) {
        db.document(self.viewDatas.email).getDocument{ (document, error) in
            self.foodNames = String(describing: document!.data()!["foodName"]!).components(separatedBy: "|")
            self.foodCounts = String(describing: document!.data()!["foodCount"]!).components(separatedBy: "|")
            self.foodPrices = String(describing: document!.data()!["foodPrice"]!).components(separatedBy: "|")
            completion(self.foodNames, self.foodCounts, self.foodPrices, true)
        }
    }
    
    func checkDuplicate(foodNames: [String]) -> Bool{
        for food in foodNames {
            if food == foodName {
                return true
            }
        }
        return false
    }
    
    
    func addCart() {
        self.foodNames.append(foodName)
        self.foodCounts.append(foodCount)
        self.foodPrices.append(foodPrice)
        
        db.document(self.viewDatas.email).setData([
            "foodName" : foodNames.joined(separator: "|"),
            "foodCount" : foodCounts.joined(separator: "|"),
            "foodPrice" : foodPrices.joined(separator: "|"),
        ], merge: true)
        
    }
}

