//
//  Mart.swift
//  refriger
//
//  Created by 조종운 on 2020/01/07.
//  Copyright © 2020 조종운. All rights reserved.
//

import SwiftUI
import Firebase
import FirebaseFirestore

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

enum RemoveAlert {
    case remove, removed, logout
}

struct SideUserInfo: View {
    
    @ObservedObject var viewDatas: ViewDatas
    
    let db = Firestore.firestore().collection("users")

    @State var email: String = ""
    @State var hp: String = ""
    @State var address: String = ""
    @State var getData: Bool = false
    
    @State var editUserInfo: Bool = false
    @State var editUserAddr: Bool = false
    @State var isRemoveAccount_Alert: Bool = false
    @State var removeState: RemoveAlert = .remove
    
    @State var p: CGSize = .zero
    
    var body: some View {
        
        ZStack {
            Group {
                if viewDatas.login {
                    VStack {
                        if getData {
                            VStack {
                                Text("\(viewDatas.name)님 안녕하세요.")
                                    .font(.system(size: 24, weight: .bold))
                                    .padding(.bottom, 10)
                                Text("정보를 추가 기입하시거나 수정할 수 있습니다.")
                                    .font(.system(size: 16))
                                    .foregroundColor(.gray).opacity(0.8)
                            }
                            .padding(.vertical, 25)
                            
                            UserInformation_Cell(cellText: "휴대폰 번호", info: hp, editUserAddr: $editUserAddr).padding(.bottom, 15)
                            
                            UserInformation_Cell(cellText: "주소 (배송지)", info: address, editUserAddr: $editUserAddr).padding(.bottom, 30)
                            
                            Spacer()
                            
                            HStack {
                                Button(action: {
                                    self.removeState = .logout
                                    self.isRemoveAccount_Alert.toggle()
                                }) {
                                    Text("로그아웃").foregroundColor(.gray)
                                }
                                
                                Text(" | ").foregroundColor(.gray)
                                
                                Button(action: {
                                    self.removeState = .remove
                                    self.isRemoveAccount_Alert.toggle()
                                }) {
                                    Text("회원탈퇴").foregroundColor(.gray)
                                }
                            }.padding(.bottom, 15)
                        }
                    }
                    .background(Color("MartBackground"))
                    .navigationBarHidden(editUserAddr ? true : false)
                    .navigationBarTitle(editUserAddr ? "" : "회원정보")
                    .onAppear {
                        self.getUserInfo { getData in
                            if getData { self.getData = true }
                        }
                    }
                } else {
                    IsNotLogin(viewDatas: viewDatas)
                }
            }
            .alert(isPresented: $isRemoveAccount_Alert) {
                switch removeState {
                case .remove:
                    return alert
                    
                case .removed:
                    return removed
                    
                case .logout:
                    return logout
                }
            }
            GeometryReader { geometry in
                SearchingAddress()
                    .offset(y: self.editUserAddr ? self.p.height : UIScreen.main.bounds.height)
                    .animation(.spring())
                    .gesture(DragGesture()
                        .onChanged { value in
                            if value.translation.height > 0 {
                                self.p.height = value.translation.height
                            }
                        }
                        .onEnded { value in
                            if value.translation.height > 200 {
                                withAnimation {
                                    self.editUserAddr = false
                                }
                                self.p = .zero
                            } else { self.p = .zero }
                        }
                )
            }
        }
    }
    
    var logout: Alert {
        Alert(
            title: Text("안녕 나의냉장고"),
            message: Text("로그아웃 하시겠습니까?"),
            primaryButton: .default(Text("로그아웃")) {
                self.viewDatas.login = false
            },
            secondaryButton: .default(Text("취소"))
        )
    }
    
    var alert: Alert {
        Alert(
            title: Text("계정 삭제"),
            message: Text("회원님의 계정을 삭제하시겠습니까?"),
            primaryButton: .default(Text("삭제")) {
                self.removeUserData()
                self.removeState = .removed
                self.viewDatas.login = false
                self.isRemoveAccount_Alert = true
            },
            secondaryButton: .default(Text("취소")) {
                self.isRemoveAccount_Alert = false
            }
        )
    }
    
    var removed: Alert {
        Alert(
            title: Text("계정 삭제"),
            message: Text("회원님의 계정이 삭제되었습니다."),
            dismissButton: .default(Text("확인"))
        )
    }
    
    func getUserInfo(completion: @escaping (Bool) -> Void) {
        db.document(self.viewDatas.email).getDocument{ (document, error) in
            self.hp = document?.data()!["HP"] as! String
            self.address = document?.data()!["address"] as! String
            
            completion(true)
        }
    }
    
    func saveUserInfo() {
        
        db.document(self.viewDatas.email).setData([
            "HP" : hp,
            "address" : address,
        ], merge: true)
    }
    
    func removeUserData() {
        let user = Auth.auth().currentUser
        
        user?.delete{ error in
            if let error = error {
                print("Error : \(error)")
            } else {
                self.db.document(self.viewDatas.email).delete()
                print("계정이 정상적으로 삭제되었음.")
            }
        }
    }
}

struct UserInformation_Cell: View {

    var cellText: String
    var info: String
    
    @Binding var editUserAddr: Bool
    
    var body: some View {
        VStack {
            /// 휴대폰 번호 입력
            if cellText == "휴대폰 번호" {
                HStack {
                    VStack(spacing: 10) {
                        HStack {
                            Text(cellText)
                                .fontWeight(.semibold)
                                .foregroundColor(.gray)
                            Spacer()
                        }
                        
                        if info == "" {
                            HStack {
                                Text("휴대폰 번호를 입력해주세요.")
                                    .foregroundColor(.black)
                                Spacer()
                            }
                        } else {
                            HStack {
                                Text(info)
                                    .foregroundColor(.black)
                                Spacer()
                            }
                        }
                    }
                    Spacer()
                    ZStack {
                        Rectangle()
                            .frame(width: 60, height: 40)
                            .foregroundColor(.white)
                            .border(Color.black)
                        
                        NavigationLink(destination: EditPhoneNumber()) {
                            Text("변경")
                                .foregroundColor(.black)
                        }
                    }
                }
                
                Divider().background(Color.gray).opacity(0.8)
            /// 주소입력
            } else {
                HStack {
                    VStack(spacing: 10) {
                        HStack {
                            Text(cellText)
                                .fontWeight(.semibold)
                                .foregroundColor(.gray)
                            Spacer()
                        }
                        
                        if info == "" {
                            HStack {
                                Text("주소를 입력해주세요.")
                                Spacer()
                            }
                        } else {
                            HStack {
                                Text(info)
                                Spacer()
                            }
                        }
                    }
                    Spacer()
                    ZStack {
                        Rectangle()
                            .frame(width: 60, height: 40)
                            .foregroundColor(.white)
                            .border(Color.black)
                        
                        Button(action: {
                            self.editUserAddr = true
                        }) {
                            Text("변경")
                                .foregroundColor(.black)
                        }
                    }
                }
                
                Divider().background(Color.gray).opacity(0.8)
            }
        }.padding(.horizontal, 15)
    }
}

struct UserInformation_EditCell: View {
    
    var cellText: String
    var cellType: String
    @Binding var cellData: String
    @Binding var changeAddress: Bool
    
    var body: some View {
        VStack {
            
            HStack {
                Text(cellText)
                    .foregroundColor(.black)
                    .fontWeight(.semibold)
                Spacer()
            }.padding(.leading, 15)
            
            if cellType == "hp" {
                VStack {
                    HStack {
                        // 휴대전화번호 입력칸
                        ZStack {
                            RoundedRectangle(cornerRadius: 5)
                                .frame(width: 200, height: 50)
                                .foregroundColor(.white)
                                .shadow(color: .gray, radius: 2, x: 1, y: 1)
                            
                            TextField("'-'을 제외하고 휴대폰 번호를 입력해주세요.", text: $cellData)
                            .keyboardType(.numberPad)
                            .padding(.leading, 15)
                        }
                        // 인증메세지 전송 버튼
                        ZStack {
                            RoundedRectangle(cornerRadius: 5)
                                .frame(height: 50)
                                .foregroundColor(.white)
                                .shadow(color: .gray, radius: 2, x: 1, y: 1)
                            
                            Button(action: {}) {
                                Text("인증")
                            }
                        }
                    }
                    
                    // 인증메세지 입력칸
                    ZStack {
                        RoundedRectangle(cornerRadius: 5)
                            .frame(width: 150, height: 50)
                            .foregroundColor(.white)
                            .shadow(color: .gray, radius: 2, x: 1, y: 1)
                    }
                }
            } else {
                ZStack {
                    RoundedRectangle(cornerRadius: 5)
                        .frame(height: 50)
                        .foregroundColor(.white)
                        .shadow(color: .gray, radius: 2, x: 1, y: 1)
                    
                    HStack {
                        if cellData == "" {
                            Text("주소를 입력해주세요.")
                                .foregroundColor(.gray).opacity(0.8)
                                .padding(.leading, 15)
                        } else {
                            Text(cellData)
                                .foregroundColor(.black)
                                .padding(.leading, 15)
                        }
                    }
                }
            }
        }
    }
}

struct EditUserInformation: View {
    
    @Binding var editUserInfo: Bool
    var email: String
    var compare_hp: String
    @Binding var hp: String
    @Binding var address: String
    
    @State var error: String = ""

    @State var changeAddress: Bool = false
    @State var edited: Bool = false
    
    let db = Firestore.firestore().collection("users")
    
    var body: some View {
        VStack {
            VStack(spacing: 15) {
                Text("회원정보 수정")
                    .font(.system(size: 24, weight: .bold))
                Text("정보를 기입하신 후 하단의 버튼을 눌러주세요.")
                    .foregroundColor(.gray).opacity(0.8)
            }.padding(.top, 40).padding(.bottom, 30)
            
            UserInformation_EditCell(cellText: "휴대폰 번호", cellType: "hp", cellData: $hp, changeAddress: $changeAddress)
            
            UserInformation_EditCell(cellText: "주소 (배송지)", cellType: "address", cellData: $address, changeAddress: $changeAddress)
            
            Text(error)
                .fontWeight(.semibold)
                .foregroundColor(.red).padding(.bottom, 25)
            
            Button(action: {
                self.saveUserInfo()
            }) {
                HStack {
                    Text("수정정보 저장")
                        .foregroundColor(.white)
                }
                .clipShape(Capsule())
                .frame(width: 300, height: 50)
                .padding(.horizontal, 20)
                .background(LinearGradient(gradient: Gradient(colors: [Color("purple"), Color("pink")]), startPoint: .topLeading, endPoint: .bottomTrailing))
                .shadow(color: .gray, radius: 2, x: 1, y: 1)
            }
            
            Spacer()
        }
        .background(Color("MartBackground"))
        .alert(isPresented: $edited, content: { return alert })
    }
    
    var alert: Alert {
        Alert(title: Text("계정 저장"), message: Text("입력하신 정보들이 성공적으로 저장되었습니다."))
    }
    
    func saveUserInfo() {
        if checkHP() {
            
            if hp.count == 11 {
                hp.insert("-", at: hp.index(hp.startIndex, offsetBy: 3))
                hp.insert("-", at: hp.index(hp.endIndex, offsetBy: -4))
            }
            
            db.document(email).setData([
                "HP" : hp,
                "address" : address,
            ], merge: true)
             
             self.edited = true
             DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                 self.editUserInfo = false
             }
        }
    }
    
    func checkHP() -> Bool {
        var check: Bool = false
        
        if self.hp.count == 11 {
            check = true
        } else if self.hp.count > 11 {
            if self.hp == self.compare_hp { check = true }
        } else {
            error = "입력하신 휴대폰번호가 올바르지 않습니다."
        }
        return check
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


