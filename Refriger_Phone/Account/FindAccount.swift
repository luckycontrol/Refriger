//
//  FindAccount.swift
//  refriger
//
//  Created by 조종운 on 2020/01/31.
//  Copyright © 2020 조종운. All rights reserved.
//

import SwiftUI

struct FindAccount: View {
    
    @State var findType = ""
    
    var body: some View {
        
        ZStack {
            
            if findType == "" {
                
                FindType(findType: $findType)
            }
        
            else if findType == "findID" {
                
                FindId()
            }
            
            else if findType == "findPass" {
                
                FindPass()
            }
            
        }.animation(.easeIn)
    }
}

struct FindType: View {
    
    @Binding var findType: String
    
    var body: some View {
        
        VStack {
            
            Text("계정을 잊어버리셨나요?")
                .font(.system(size: 24, weight: .heavy))
            
            HStack {
                
                Button(action: {
                    self.findType = "findID"
                }) {
                    
                    HStack {
                        
                        Text("아이디 찾기")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    .frame(width: 170, height: 170)
                    .background(LinearGradient(gradient: Gradient(colors: [Color("purple"), Color("pink")]), startPoint: .top, endPoint: .bottom))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.white, lineWidth: 1))
                    .shadow(radius: 10)
                }
                
                Button(action: {
                    self.findType = "findPass"
                }) {
                    
                    HStack {
                        
                        Text("비밀번호 찾기")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    .frame(width: 170, height: 170)
                    .background(LinearGradient(gradient: Gradient(colors: [Color("purple"), Color("pink")]), startPoint: .top, endPoint: .bottom))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.white, lineWidth: 1))
                    .shadow(radius: 10)
                }
            }
            .padding(.top, 80)
            
            Spacer()
            
        }
        .padding(.top, 80)
    }
}

// 아이디 찾기
struct FindId: View {
    
    @State var email = ""
    @State var password = ""
    
    @State var alert = false
    @State var alertComment = ""
    
    var body: some View {
        
        VStack {
            
            Text("아이디 찾기")
                .font(.system(size: 28, weight: .heavy))
            
            VStack(spacing: 20) {
                VStack {
                    
                    HStack {
                        
                        Image("email")
                            .resizable()
                            .frame(width: 20, height: 20)
                        TextField("이메일을 입력하세요.", text: $email)
                    }
                    Divider()
                }
                
                VStack {
                    
                    HStack {
                        
                        Image(systemName: "lock.fill")
                            .resizable()
                            .frame(width: 20, height: 20)
                        SecureField("비밀번호를 입력하세요.", text: $password)
                    }
                    Divider()
                }
            }
            .padding(.horizontal, 50)
            .padding(.top, 80)
            .padding(.bottom, 150)
            
            Button(action: {
                self.checkAccount(email: self.email, pass: self.password)
            }) {
                
                HStack {
                    
                    Text("아이디 찾기")
                        .font(.system(size: 22, weight: .heavy))
                        .foregroundColor(.white)
                }
                .frame(width: 300, height: 50)
                .background(LinearGradient(gradient: Gradient(colors: [Color("purple"), Color("pink")]), startPoint: .top, endPoint: .bottom))
                .clipShape(Capsule())
                .overlay(Capsule().stroke(Color.white, lineWidth: 1))
                .shadow(radius: 10)
            }
            
            
            
            Spacer()
            
            
        }.padding(.top, 60)
        .alert(isPresented: $alert, content: { self.accountAlert })
    }
    
    var accountAlert: Alert {
        Alert(title: Text("다시 입력해주세요."), message: Text(alertComment), dismissButton: .default(Text("확인")))
    }
    
    func checkAccount(email: String, pass: String) {
        
        var emailCheck: Bool = false
        
        for i in email {
            
            if i == "@" {
                emailCheck = true
            }
        }
        
        if emailCheck == false {
            self.alert = true
            self.alertComment = "이메일 형식을 올바르게 기입해주세요."
        }
        
        if email == "" || pass == "" {
            self.alert = true
            self.alertComment = "입력하지 않은 항목이 있습니다."
            return
        }
        
        // 디비에서 이메일 - 아이디 확인
    }
}

// 비밀번호 찾기
struct FindPass: View {
    
    @State var email: String = ""
    @State var userId: String = ""
    
    @State var alert: Bool = false
    @State var alertComment: String = ""
    
    var body: some View {
        
        VStack {
            
            Text("비밀번호 찾기")
                .font(.system(size: 28, weight: .heavy))
            
            VStack(spacing: 20) {
                VStack {
                    
                    HStack {
                        
                        Image("email")
                            .resizable()
                            .frame(width: 20, height: 20)
                        TextField("이메일을 입력하세요.", text: $email)
                    }
                    Divider()
                }
                
                VStack {
                    
                    HStack {
                        
                        Image(systemName: "person")
                            .resizable()
                            .frame(width: 20, height: 20)
                        SecureField("아이디를 입력하세요.", text: $userId)
                    }
                    Divider()
                }
            }
            .padding(.horizontal, 50)
            .padding(.top, 80)
            .padding(.bottom, 150)
            
            Button(action: {
                self.checkAccount(email: self.email, userId: self.userId)
            }) {
                
                HStack {
                    
                    Text("비밀번호 찾기")
                        .font(.system(size: 22, weight: .heavy))
                        .foregroundColor(.white)
                }
                .frame(width: 300, height: 50)
                .background(LinearGradient(gradient: Gradient(colors: [Color("purple"), Color("pink")]), startPoint: .top, endPoint: .bottom))
                .clipShape(Capsule())
                .overlay(Capsule().stroke(Color.white, lineWidth: 1))
                .shadow(radius: 10)
            }
            
            
            
            Spacer()
            
            
        }.padding(.top, 60)
        .alert(isPresented: $alert, content: { self.accountAlert })
    }
    
    var accountAlert: Alert {
        Alert(title: Text("다시 입력해주세요."), message: Text(alertComment), dismissButton: .default(Text("확인")))
    }
    
    func checkAccount(email: String, userId: String) {
        
        var emailCheck: Bool = false
        
        for i in email {
            
            if i == "@" {
                emailCheck = true
            }
        }
        
        if emailCheck == false {
            self.alert = true
            self.alertComment = "이메일 형식을 올바르게 기입해주세요."
        }
        
        if email == "" || userId == "" {
            self.alert = true
            self.alertComment = "입력하지 않은 항목이 있습니다."
            return
        }
        
        // 디비에서 이메일 - 아이디 확인
    }
}
