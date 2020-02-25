//
//  SelfAddFood.swift
//  Refriger
//
//  Created by 조종운 on 2020/02/07.
//  Copyright © 2020 조종운. All rights reserved.
//

import SwiftUI

struct selfAddFood: View {
    
    @ObservedObject var selfData: SelfAddData = SelfAddData()
    
    @State var add: Bool = false
    
    @State var p: CGSize = .zero
    
    @State var input: Bool = false

    @State var delete: Bool = false
    @State var index: Int = 0
    
    var body: some View {
        
        ZStack {
            
            Color("MartBackground")
            
            ScrollView(.vertical, showsIndicators: false) {
                
                ForEach(0 ..< selfData.selfAddDataList.count, id: \.self) { i in
                    
                    SelfAddCell(
                        // 수정
                        selfData: self.selfData,
                        delete: self.$delete,
                        index: i
                    )
                        .onTapGesture {
                            self.index = self.selfData.selfAddDataList[i].id
                            self.input.toggle()
                    }
                }
            }
            
            GeometryReader{_ in
                
                VStack {
                    Spacer()
                    
                    HStack{
                        SelfSideButtons(selfData: self.selfData, add: self.$add)
                        Spacer()
                    }
                }
            }
        }
        .alert(isPresented: $add) {
            Alert(title: Text("저장 완료"), message: Text("입력하신 식자재들이 저장되었습니다."))
        }
        .sheet(isPresented: $input) {
            InputData(selfData: self.selfData, index: self.index)
        }
        .navigationBarTitle("식자재 직접 추가")
    }
}

struct SelfAddCell: View {
    
    @ObservedObject var selfData:SelfAddData
    
    @Binding var delete: Bool
    
    var index: Int
    
    let dateFormatter: DateFormatter = {
        var formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    var body: some View {
        
        ZStack {
            
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(.white)
                .frame(height: 100)
                .shadow(color: .gray, radius: 1, x: 2, y: 2)
            
            HStack {
                
                if selfData.selfAddDataList[index].foodName == "" {
                    Text("클릭하여 데이터를 추가해보세요.")
                } else {
                    HStack {
                        Image(self.selfData.selfAddDataList[index].foodType+"선택")
                            .resizable().frame(width: 60, height: 60)
                            .padding(.trailing, 25)
                        
                        VStack(spacing: 8) {
                            
                            Text(self.selfData.selfAddDataList[index].foodType)
                                .foregroundColor(.gray)
                                .opacity(0.8)
                            Text(self.selfData.selfAddDataList[index].foodName)
                                .foregroundColor(.black).fontWeight(.semibold)
                            Text(dateFormatter.string(from: self.selfData.selfAddDataList[index].expiration))
                        }
                    }
                }
                
            }.padding(.horizontal)
            
        }
        .padding(.horizontal)
        .padding(.vertical)
    }
    
    func deleteCell() {
        self.selfData.selfAddDataList.remove(at: self.index)
    }
}
struct SelfSideButtons: View {
    
    @ObservedObject var selfData: SelfAddData
    
    @Binding var add: Bool
    
    @Environment(\.managedObjectContext) var context
    
    @State var plusButton1: Bool = false
    @State var plusButton2: Bool = false
    
    var body: some View {
        
        VStack {
            
            if plusButton1 {
                
                Button(action: {
                    self.selfData.selfAddDataList.append(selfAddData())
                    self.selfData.selfAddDataList[self.selfData.selfAddDataList.count - 1].id = self.selfData.selfAddDataList.count - 1
                }) {
                    PlusButton(image: "plus")
                }.transition(.move(edge: .leading))
            }
            
            if plusButton2 {
                
                Button(action: {
                    self.addFood()
                    self.add = true
                }) {
                    PlusButton(image: "folder.badge.plus")
                }.transition(.move(edge: .leading))
            }
            
            Button(action: { self.showButtons() }) {
                PlusButton(image: "pencil")
            }
            
        }.padding()
    }
    
    /// 직접추가 버튼
    func addFood() {
        
        for c in selfData.selfAddDataList {
            
            if c.foodName != "" && c.foodType != "" {
                let newFood = Food(context: context)
                
                newFood.id = UUID()
                newFood.foodName = c.foodName
                newFood.expiration = c.expiration
                newFood.foodType = c.foodType
                
                do { try context.save() } catch { print(error) }
            }
        }
        
        selfData.selfAddDataList.removeAll()
        selfData.selfAddDataList.append(selfAddData())
    }
    
    func showButtons() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            withAnimation {
                self.plusButton1.toggle()
            }
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
            withAnimation {
                self.plusButton2.toggle()
            }
        })
    }
}

struct InputData: View {
    
    @ObservedObject var selfData: SelfAddData

    var index: Int
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 15) {
        
            Text("식자재 정보를 입력하세요.")
                .foregroundColor(.black)
                .font(.system(size: 22, weight: .bold))
                .padding(.vertical, 25)
            
            ScrollView(.vertical, showsIndicators: false) {
                
                Text("식자재 이름")
                    .font(.headline)
                TextField("식자재 이름을 입력하세요.", text: self.$selfData.selfAddDataList[index].foodName)
                    .padding(.all)
                    .background(Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0))
                    .cornerRadius(5)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 25) {
                        TypeCell(foodType: self.$selfData.selfAddDataList[index].foodType, image: "과일", text: "과일")
                        TypeCell(foodType: self.$selfData.selfAddDataList[index].foodType, image: "채소", text: "채소")
                        TypeCell(foodType: self.$selfData.selfAddDataList[index].foodType, image: "정육", text: "정육")
                        TypeCell(foodType: self.$selfData.selfAddDataList[index].foodType, image: "유제품", text: "유제품")
                    }.padding(.vertical, 15)
                }.padding(.vertical, 25)
                
                Text("유통기한")
                    .font(.headline)
                
                ZStack{
                    
                    RoundedRectangle(cornerRadius: 5)
                        .foregroundColor(.white)
                        .shadow(color: .gray, radius: 2, x: 2, y: 2)
                    
                    DatePicker("", selection: self.$selfData.selfAddDataList[index].expiration, in: Date()... ,displayedComponents: .date)
                    .labelsHidden()
                }
            }
            
        }.padding(.horizontal, 15)
    }
}

struct TypeCell: View {
    
    @Binding var foodType: String
    var image: String
    var text: String
    
    var body: some View {
        
        ZStack {
            
            RoundedRectangle(cornerRadius: 5)
                .frame(width: 150, height: 150)
                .foregroundColor(.white)
                .shadow(color: .gray, radius: 1, x: 1, y: 2)
        
            Button(action: {
                self.foodType = self.text
                
            }) {
                VStack(spacing: 8) {
                    Image(foodType == text ? "\(text)선택" : image)
                        .renderingMode(.original)
                    Text(foodType == text ? text+"선택됨" : text)
                        .foregroundColor(.black)
                        .fontWeight(.semibold)
                }
            }
        }
    }
}

struct SelectDateView: View{
    
    @Binding var expiration: Date
    
    let index: Int
    
    var body: some View {
        
        VStack {
            
            Text("유통기한을 선택해주세요.")
                .font(.system(size: 24, weight: .bold))
                .padding(.bottom, 25)
        
            DatePicker("", selection: $expiration, in: Date()... ,displayedComponents: .date)
            .labelsHidden()
            
        }
    }
}

struct SelfRightNav: View {
    
    @Binding var delete: Bool
    
    var body: some View {
        
        Button(action: { self.delete.toggle() }) {
            Text(delete ? "수정완료" : "목록수정")
        }
    }
}

struct PlusButton: View {
    
    var image: String
    
    var body: some View {
        
        ZStack {
            
            Circle()
                .frame(width: 50, height: 50)
                .foregroundColor(Color("Color"))
                .shadow(color: .gray, radius: 1, x: 1, y: 2)
            Image(systemName: image)
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundColor(.white)
        }
        .shadow(color: .gray, radius: 0.2, x: 1, y: 1)
    }
}
