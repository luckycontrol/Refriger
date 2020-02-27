//
//  Mart.swift
//  refriger
//
//  Created by 조종운 on 2020/01/07.
//  Copyright © 2020 조종운. All rights reserved.
//

import SwiftUI

struct Mart: View {
    
    @EnvironmentObject var session: SessionStore
    
    @ObservedObject var viewDatas = ViewDatas()
    
    @State var sideBar: Bool = false
    
    @State var sorting: Bool = false
    
    var body: some View {
        
        NavigationView {
            UpperView(viewDatas: viewDatas, sideBar: $sideBar, sorting: $sorting)
        }
    }
}

struct UpperView: View {
    
    @ObservedObject var viewDatas: ViewDatas
    
    @Binding var sideBar: Bool
    
    @Binding var sorting: Bool
    
    @State var p: CGSize = .zero
    
    var body: some View {
        
        
        ZStack {
 
            /// MARK - 스크롤 뷰 ( 메인 )
            MainView(viewDatas: viewDatas, sorting: $sorting)
            
            GeometryReader { geometry in
                
                HStack {
                    SideMenu(viewDatas: self.viewDatas, sideBar: self.$sideBar)
                        .offset(x: self.sideBar ? self.p.width : -UIScreen.main.bounds.width)
                        .animation(.spring())
                        .gesture(DragGesture()
                            .onChanged{ value in
                                if value.translation.width < 0 {
                                    self.p.width = value.translation.width
                                }
                            }
                            .onEnded{ value in
                                if value.translation.width < -120 {
                                    withAnimation {
                                        self.sideBar = false
                                    }
                                    self.p = .zero
                                } else { self.p = .zero }
                        })
                    
                    Spacer()
                }
            }
            .background(Color.black.opacity(self.sideBar ? 0.5 : 0))
            
        }
        .navigationBarItems(leading: LeftNav(sideBar: $sideBar), trailing: RightNav(viewDatas: viewDatas))
        .navigationBarTitle("Cho Mart", displayMode: .inline)
        .sheet(isPresented: $sorting) { SortingView() }
        
    }
}

struct SortingView: View {
    
    var body: some View {
        
        Text("test")
    }
}

struct LeftNav: View {
    
    @Binding var sideBar: Bool
    
    var body: some View {
        
        Button(action: { self.sideBar.toggle() }) {
            
            if sideBar {
                Image("backArrow")
                    .resizable()
                    .frame(width: 30, height: 30)
            } else {
                Image(systemName: "list.bullet")
                    .resizable()
                    .frame(width: 20, height: 20)
            }
        }.onDisappear{ self.sideBar = false }
    }
}

struct RightNav: View {
    
    @ObservedObject var viewDatas: ViewDatas
    
    var body: some View {
        
        HStack(spacing: 20) {
            
            NavigationLink(destination: SelectList(viewDatas: viewDatas)) {
                
                Image(systemName: "cart")
                    .resizable()
                    .frame(width: 20, height: 20)
            }
        }
    }
}

struct SideMenu: View {
    
    @ObservedObject var viewDatas: ViewDatas
    
    @Binding var sideBar: Bool
    
    @State var fruit: Bool = false
    @State var vegetable: Bool = false
    @State var meat: Bool = false
    
    var body: some View {
        
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                
                SideUserMenu(viewDatas: viewDatas)
                
                HStack{
                    Text("카테고리")
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding(.vertical, 8)
                .padding(.leading, 10)
                
                Divider().background(Color.gray).padding(.horizontal, 10)
                
                VStack(spacing: 20) {
                    
                    SideFoodButton(food: $fruit, categoryName: "과일")
                    
                    if fruit {
                        SideFruit(viewDatas: viewDatas, sideBar: $sideBar)
                    }
                    
                    SideFoodButton(food: $vegetable, categoryName: "채소")
                    
                    if vegetable {
                        SideVegetable(viewDatas: viewDatas, sideBar: $sideBar)
                    }
                    
                    SideFoodButton(food: $meat, categoryName: "정육")
                    
                    if meat {
                        SideMeat(viewDatas: viewDatas, sideBar: $sideBar)
                    }
                }
                .padding([.horizontal, .vertical])
                
                Spacer()
                
                if viewDatas.login {
                    Button(action: { self.viewDatas.login = false }) {
                        HStack(spacing: 10) {
                            Image(systemName: "arrow.uturn.left")
                            Text("로그아웃")
                            Spacer()
                        }.foregroundColor(.white)
                    }.padding([.leading, .bottom], 15)
                }
            }
        }
        .frame(width: 300)
        .background(Color("Color"))
    }
}

struct SideUserMenu: View {
    
    @ObservedObject var viewDatas: ViewDatas
    
    var body: some View {
        
        VStack {
            
            HStack {
                NavigationLink(destination: SideUserInfo(viewDatas: viewDatas)) {
                    HStack(spacing: 15) {
                        Image(systemName: "person.circle.fill")
                            .resizable().frame(width: 40, height: 40)
                            .foregroundColor(.white)
                        Text("회원정보").foregroundColor(.white).font(.system(size: 16, weight: .semibold))
                    }
                }
                Spacer()
            }
            .padding(.top, 30)
            .padding(.leading, 10)
            Divider().background(Color.gray).padding(.horizontal, 10)
            
            HStack {
                NavigationLink(destination: SelectList(viewDatas: viewDatas)) {
                    HStack(spacing: 15) {
                        Image(systemName: "cart")
                            .resizable().frame(width: 20, height: 20)
                            .foregroundColor(.white)
                        Text("장바구니").foregroundColor(.white)
                    }
                }
                Spacer()
            }
            .padding(.vertical, 8)
            .padding(.leading, 10)
            Divider().background(Color.gray).padding(.horizontal, 10)
        }
    }
}

struct SideFoodButton: View {
    
    @Binding var food: Bool
    let categoryName: String
    
    var body: some View {
        Button(action: { withAnimation{ self.food.toggle() } }) {
            HStack {
                Text("\(categoryName)").padding(.leading, 10)
                Spacer()
                Image(self.food ? "upperArrowBlack" : "downArrowBlack")
            }
            .frame(height: 30)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 5))
        }
    }
}

struct SideUserInfo: View {
    
    @ObservedObject var viewDatas: ViewDatas
    
    var body: some View {
        Group {
            if viewDatas.login {
                Text("유저 정보")
            }
            else {
                IsNotLogin(viewDatas: viewDatas)
            }
        }
    }
}

struct SideFruit: View {
    
    @ObservedObject var viewDatas: ViewDatas
    
    @Binding var sideBar: Bool
    
    var body: some View {
        
        VStack {
            
            VStack(spacing: 15) {
                
                Button(action: {
                    self.viewDatas.category = "과일"
                    self.viewDatas.foodName = "딸기 / 블루베리"
                    withAnimation { self.sideBar = false }
                }) {
                    HStack {
                        Text("딸기 / 블루베리")
                        Spacer()
                    }
                }
                
                Button(action: {
                    self.viewDatas.category = "과일"
                    self.viewDatas.foodName = "감귤 / 한라봉"
                    withAnimation { self.sideBar = false }
                }) {
                    HStack {
                        Text("감귤 / 한라봉")
                        Spacer()
                    }
                }
                
                Button(action: {
                    self.viewDatas.category = "과일"
                    self.viewDatas.foodName = "사과"
                    withAnimation { self.sideBar = false }
                }) {
                    HStack {
                        Text("사과")
                        Spacer()
                    }
                }
            }.padding([.vertical, .horizontal])
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 5))
    }
}

struct SideVegetable: View {
    
    @ObservedObject var viewDatas: ViewDatas
    
    @Binding var sideBar: Bool
    
    var body: some View {
        
        VStack {
            
            VStack(spacing: 15) {
                Button(action: {
                    self.viewDatas.category = "채소"
                    self.viewDatas.foodName = "고구마 / 감자"
                    withAnimation { self.sideBar = false }
                }) {
                    HStack {
                        Text("고구마 / 감자")
                        Spacer()
                    }
                }
                
                Button(action: {
                    self.viewDatas.category = "채소"
                    self.viewDatas.foodName = "상추 / 깻잎"
                    withAnimation { self.sideBar = false }
                }) {
                    HStack {
                        Text("상추 / 깻잎")
                        Spacer()
                    }
                }
                
                Button(action: {
                    self.viewDatas.category = "채소"
                    self.viewDatas.foodName = "시금치 / 부추"
                    withAnimation { self.sideBar = false }
                }) {
                    HStack {
                        Text("시금치 / 부추")
                        Spacer()
                    }
                }
            }.padding([.vertical, .horizontal])
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 5))
    }
}

struct SideMeat: View {
    
    @ObservedObject var viewDatas: ViewDatas
    
    @Binding var sideBar: Bool
    
    var body: some View {
        
        VStack {
            
            VStack(spacing: 15){
                Button(action: {
                    self.viewDatas.category = "정육"
                    self.viewDatas.foodName = "소고기"
                    withAnimation { self.sideBar = false }
                }) {
                    HStack {
                        Text("소고기")
                        Spacer()
                    }
                }
                
                Button(action: {
                    self.viewDatas.category = "정육"
                    self.viewDatas.foodName = "돼지고기"
                    withAnimation { self.sideBar = false }
                }) {
                    HStack {
                        Text("돼지고기")
                        Spacer()
                    }
                }
                
                Button(action: {
                    self.viewDatas.category = "정육"
                    self.viewDatas.foodName = "닭 / 오리고기"
                    withAnimation { self.sideBar = false }
                }) {
                    HStack {
                        Text("닭 / 오리고기")
                        Spacer()
                    }
                }
            }.padding([.vertical, .horizontal])
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 5))
    }
}

// 검색, 정렬방식변경 뷰
struct MainView: View {
    
    @ObservedObject var viewDatas: ViewDatas
    
    @Binding var sorting: Bool
    
    @State var selectFood = false
    
    var body: some View {
            
        VStack {
        
            /// MARK - 검색, 정렬방식변경 뷰
            SearchBar(sorting: $sorting)
            
            DetailScroll(viewDatas: viewDatas)
            
        }.background(Color("MartBackground"))
    }
}

// 음식들 출력 - 스크롤 뷰
struct DetailScroll: View {
    
    @ObservedObject var viewDatas: ViewDatas
    
    var body: some View {
        
        
        ScrollView(.vertical, showsIndicators: false) {
          
            if viewDatas.category == "과일" {
                
                if viewDatas.foodName == "딸기 / 블루베리" {
                    FoodCell(viewDatas: viewDatas, food: fruit[0].row)
                    
                } else if viewDatas.foodName == "감귤 / 한라봉" {
                    FoodCell(viewDatas: viewDatas, food: fruit[1].row)
                } else {
                    FoodCell(viewDatas: viewDatas, food: fruit[2].row)
                }
            }
            else if viewDatas.category == "채소" {
                
                if viewDatas.foodName == "고구마 / 감자" {
                    FoodCell(viewDatas: viewDatas, food: vegetable[0].row)
                    
                } else if viewDatas.foodName == "상추 / 깻잎" {
                    FoodCell(viewDatas: viewDatas, food: vegetable[1].row)
                } else {
                    FoodCell(viewDatas: viewDatas, food: vegetable[2].row)
                }
                
            }
            else if viewDatas.category == "정육" {
                
                if viewDatas.foodName == "소고기" {
                    FoodCell(viewDatas: viewDatas, food: meat[0].row)
                    
                } else if viewDatas.foodName == "돼지고기" {
                    FoodCell(viewDatas: viewDatas, food: meat[1].row)
                } else {
                    FoodCell(viewDatas: viewDatas, food: meat[2].row)
                }
                
            }
        }
        
    }
}


