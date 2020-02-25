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

struct RefrigerList: View {
    
    @State var qrcode: Bool = false
    
    @State var show: Bool = false
    
    @State var filter: String = "전체"
    
    @State var delete: Bool = false
    
    @State var p: CGSize = .zero
    
    let notificationManager = NotificationManager()
    
    @FetchRequest(entity: Food.entity(),
                  sortDescriptors: [NSSortDescriptor(keyPath: \Food.expiration, ascending: false)]
    ) var foodDatas: FetchedResults<Food>
        
    var body: some View {
        
        NavigationView {
        
            ZStack {
                
                Color("MartBackground")
                
                ShowAllFoods(filter: $filter, delete: $delete)
                    .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
                        self.noti()
                }
                
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
            CodeScannerView(codeTypes: [.qr], simulatedData: "테스트용", completion: self.handleScan)
        }
    }
    
    /// 알람 메서드
    func noti() -> Void {
        
        var aWeek: String = ""
        var befor3Days: String = ""
        var befor1Days: String = ""
        var dDays: String = ""
        var trash: String = ""
        let hour: Int = 7
        
        let check: [String] = [aWeek, befor3Days, befor1Days, dDays, trash]
        let text: [String] = ["일주일 남았습니다.", "3일 남았습니다.", "하루 남았습니다.", "오늘까지입니다.", "유통기한이 지났습니다"]
        
        let calendar = Calendar.current
        
        for f in foodDatas {
            let dateGap = calendar.dateComponents([.day], from: Date(), to: f.expiration!)
            
            if dateGap.day == 7 { aWeek = aWeek + f.foodName!}
            else if dateGap.day == 3 { befor3Days = befor3Days + f.foodName!}
            else if dateGap.day == 1 { befor1Days = befor1Days + f.foodName!}
            else if dateGap.day == 0 { dDays = dDays + f.foodName!}
            else { trash = trash + f.foodName! }
        }
        
        for i in 0 ..< check.count {
            if check[i] != "" {
                print(check[i])
                notificationManager.sendNotification(food: check[i], leftTime: text[i], hour: hour)
            }
        }
    }
    
    func handleScan(result: Result<String, CodeScannerView.ScanError>) {
        self.qrcode = false
        
        switch result {
            
            case .success(let code):
                let details = code.components(separatedBy: "\n")
                print(details)
            
                
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
                Image("\(food.foodType!)선택")
                    .resizable().frame(width: 60, height: 60)
                
                VStack(spacing: 8) {
                    Text(food.foodName!)
                        .foregroundColor(.black).fontWeight(.semibold)
                    Text("유통기한 : \(dataFormatter.string(from: food.expiration!))")
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
