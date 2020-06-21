 //
//  RefrigerList.swift
//  Refriger
//
//  Created by 조종운 on 2020/02/07.
//  Copyright © 2020 조종운. All rights reserved.
//

import SwiftUI

import SwiftUI
import CoreData
import CodeScanner
import Firebase
import FirebaseFirestoreSwift

struct RefrigerList: View {
    
    @State private var qrcode: Bool = false
    
    @State var show: Bool = false
    
    @State var filter: String = "전체"
    
    @State var delete: Bool = false
    
    @State var p: CGSize = .zero
    
    let db = Firestore.firestore().collection("Orders")
    
    @FetchRequest(entity: Food.entity(),
                  sortDescriptors: [NSSortDescriptor(keyPath: \Food.expiration, ascending: false)]
    ) var foodDatas: FetchedResults<Food>
    
    @Environment(\.managedObjectContext) var context
    
    @State var qr_txt: String = ""
        
    var body: some View {
        
        NavigationView {
        
            ZStack {
                
                Color("MartBackground")
                Text(qr_txt)
                
                ShowAllFoods(filter: $filter, delete: $delete)
                
                GeometryReader { geometry in
                    
                    HStack {
                        Menu(qrcode: self.$qrcode, filter: self.$filter, show: self.$show)
                            .offset(x: self.show ? self.p.width : -UIScreen.main.bounds.width)
                            .animation(.interactiveSpring(response: 0.6, dampingFraction: 0.6, blendDuration: 0.6))
                            .gesture(DragGesture()
                                .onChanged{ value in
                                    if value.translation.width < 0 {
                                        self.p.width = value.translation.width
                                    }
                                }
                                .onEnded{ value in
                                    if self.p.width < -120.0 {
                                        withAnimation { self.show = false}
                                        self.p = .zero
                                    }
                                    else { self.p = .zero }
                                })
                        Spacer()
                    }
                }
                .background(Color.black.opacity(self.show ? 0.5 : 0))
                .onTapGesture { self.show = false }
            }
            .navigationBarItems(leading: LeftButton(show: $show), trailing: RightButton(delete: $delete))
            .navigationBarTitle("식자재 목록", displayMode: .inline)
        }
        .sheet(isPresented: $qrcode) {
            CodeScannerView(codeTypes: [.qr], simulatedData: "테스트용/1", completion: self.handleScan)
        }
    }
    
    func handleScan(result: Result<String, CodeScannerView.ScanError>) {
        self.qrcode = false
        
        switch result {
            
            case .success(let code):
                let details = code.components(separatedBy: "/")
                db.document(details[0]).getDocument { (document, error) in
                    
                    var savedFoodList: [SavedFoodType] = []
                    
                    let foodNames = String(describing: document!.data()!["foodNames"]!).components(separatedBy: "-")[Int(details[1])!].components(separatedBy: "|")
                    
                    let foodTypes = String(describing: document!.data()!["foodTypes"]!).components(separatedBy: "-")[Int(details[1])!].components(separatedBy: "|")
                    
                    let foodExpirations = String(describing: document!.data()!["foodExpirations"]!).components(separatedBy: "/")[Int(details[1])!].components(separatedBy: "|")
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    
                    for i in 0 ..< foodNames.count {
                        savedFoodList.append(SavedFoodType(foodName: foodNames[i], foodType: foodTypes[i], foodExpiration: dateFormatter.date(from: foodExpirations[i])!))
                    }
                    
                    for food in savedFoodList {
                        let newFood = Food(context: self.context)
                        newFood.id = UUID()
                        newFood.foodName = food.foodName
                        newFood.expiration = food.foodExpiration
                        newFood.foodType = food.foodType
                        
                        do { try self.context.save() } catch { print(error) }
                    }
                }
                
            case .failure(let error):
                print(error)
        }
    }
}

struct RefrigerListCell: View {
    
    @Environment(\.managedObjectContext) var context
    
    @Binding var delete: Bool
    
    var food: Food
    
    let dataFormatter: DateFormatter = {
        var formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    let foodType: String?
    let foodName: String?
    let foodDate: String?
    
    init(delete: Binding<Bool>, food: Food) {
        self._delete = delete
        self.food = food
        
        self.foodType = food.foodType
        self.foodName = food.foodName
        self.foodDate = self.dataFormatter.string(from: food.expiration!)
    }
    
    var body: some View {
        
        ZStack {
            
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(.white)
                .frame(height: 100)
                .shadow(color: .gray, radius: 1, x: 2, y: 2)
            
            HStack {
                
                if delete {
                    
                    Button(action: { self.deleteCell() }) {
                        Image(systemName: "minus.rectangle")
                            .foregroundColor(.red)
                    }
                    .padding(.trailing, 15)
                    .offset(x: -3, y: -3)
                }
                // 데이터의 주소를 보내지말고 값만 보내서 출력시킬것
                Image("\(foodType ?? "")선택")
                    .resizable().frame(width: 60, height: 60)
                
                VStack(spacing: 8) {
                    Text(foodName ?? "")
                        .foregroundColor(.black).fontWeight(.semibold)
                    Text("유통기한 : \(foodDate ?? "")")
                }
            }.padding(.horizontal)
        }
        .padding(.horizontal)
        .padding(.vertical)
    }
 
    func deleteCell() {
        
        self.context.delete(self.food)
        
        do {
            try context.save()
        } catch { print(error) }
    }
}

struct LeftButton: View {
    
    @Binding var show: Bool
    
    var body: some View {
        
        Button(action: { self.show.toggle() }) {
            
            if show {
                Image("backArrow")
                    .resizable()
                    .frame(width: 30, height: 30)
            } else {
                Image(systemName: "list.bullet")
                    .resizable()
                    .frame(width: 20, height: 20)
            }
        }.onDisappear{ self.show = false }
    }
}
 
 
 struct RightButton: View {
    
    @Binding var delete: Bool
    
    var body: some View {
        
        HStack {
            Button(action: { withAnimation { self.delete.toggle() }
            }) { Text(self.delete ? "수정완료" : "목록수정") }
        }
    }
 }

struct Menu: View {
    
    @Binding var qrcode: Bool
    
    @Binding var filter: String
    
    @Binding var show: Bool
    
    var body: some View {
        
        VStack(spacing: 15) {
            
            Spacer()
            
            Text("식자재 추가")
                .font(.system(size: 22, weight: .bold))
            VStack {
                Divider()
                Button(action: { self.qrcode = true }) {
                    VStack{
                        Image(systemName: "qrcode")
                            .resizable()
                            .frame(width: 40, height: 40)
                        Text("QRcode")
                    }
                }
                
                NavigationLink(destination: selfAddFood().onAppear{ self.show = false }) {
                    VStack {
                        Image(systemName: "pencil")
                            .resizable()
                            .frame(width: 40, height: 40)
                        Text("직접 입력")
                    }
                }
                Divider()
            }
            .padding(.horizontal, 15)
            
            
            Text("카테고리")
                .font(.system(size: 22, weight: .bold))
            VStack(spacing: 20) {
                Divider()
                Button(action: {
                    self.filter = "전체"
                    self.show = false
                }) {
                    Text("전체")
                }
                
                Button(action: {
                    self.filter = "과일"
                    self.show = false
                }) {
                    Text("과일")
                }
                
                Button(action: {
                    self.filter = "채소"
                    self.show = false
                }) {
                    Text("채소")
                }
                
                Button(action: {
                    self.filter = "정육"
                    self.show = false
                }) {
                    Text("정육")
                }
                
                Button(action: {
                    self.filter = "유제품"
                    self.show = false
                }) {
                    Text("유제품")
                }
                Divider()
            }.padding(.horizontal, 15)
            
            Spacer()
            
        }
        .frame(width: 200)
        .background(Color.white)
    }
}
 
struct SavedFoodType {
    var foodName: String
    var foodType: String
    var foodExpiration: Date
}
