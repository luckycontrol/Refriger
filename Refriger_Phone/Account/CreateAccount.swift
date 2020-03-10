//
//  CreateAccount.swift
//  refriger
//
//  Created by 조종운 on 2020/01/31.
//  Copyright © 2020 조종운. All rights reserved.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct CreateAccount: View {
    
    @EnvironmentObject var session: SessionStore
    let db = Firestore.firestore().collection("users")
    
    @ObservedObject var viewDatas: ViewDatas
    
    @State var name: String = ""
    @State var email: String = ""
    @State var password: String = ""
    @State var checkPassword: String = ""
    
    @State var check: Bool = false
    @State var error: String = ""
    
    var body: some View {
        
        ScrollView {
            
            VStack(spacing: 20) {
                Text("계정 생성")
                    .font(.system(size: 34, weight: .heavy))
                
                Text("식자재를 빠르고 쉽게 준비하세요!")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.gray).opacity(0.4)
                
            }.padding(.top, 30)
            
            VStack(spacing: 20) {
                
                InputBox(secure: false, image: "person.fill", placeholder: "이름을 입력하세요.", text: $name)
                
                InputBox(secure: false, image: "envelope", placeholder: "이메일을 입력하세요.", text: $email)
                
                InputBox(secure: true, image: "lock.fill", placeholder: "비밀번호를 입력하세요. (최소 6자 이상)", text: $password)
                
                InputBox(secure: true, image: "lock.fill", placeholder: "비밀번호를 다시 입력하세요.", text: $checkPassword)
                
                Text(check ? "계정이 생성되었습니다." : error)
                    .foregroundColor(check ? .blue : .red)
                    .font(.system(size: 15, weight: .semibold))
            }
            .padding(.horizontal, 50)
            .padding(.top, 80)
            .padding(.bottom, 40)
            
            Button(action: {
                self.checkAccount(email: self.email, pass: self.password, rePass: self.checkPassword)
            }) {
                HStack {
                    
                    Text("계정생성")
                        .font(.system(size: 18))
                        .foregroundColor(.white)
                }
                .frame(width: 300, height: 50)
                .background((LinearGradient(gradient: Gradient(colors: [Color("purple"), Color("pink")]), startPoint: .topLeading, endPoint: .bottomTrailing)))
                .clipShape(RoundedRectangle(cornerRadius: 5))
                .shadow(radius: 5)
            }.padding(.bottom, 50)
        }
    }
    
    func signUp() {
        session.signUp(email: email, password: password) { (result, error) in
            if error == nil {
                // firestore 문서 이름 = 사용자 이름
                self.db.document(self.email).setData([
                    "HP" : "",
                    "address" : "",
                    "email" : self.email,
                    "name" : self.name,
                    "foodName" : "",
                    "foodCount" : "",
                    "foodPrice" : "",
                ])
                self.check = true
                self.viewDatas.email = self.email
                
                self.email = ""
                self.password = ""
                self.checkPassword = ""
                self.name = ""
            } else {
                print(error!)
                self.error = "이미 해당 이메일이 존재합니다."
            }
        }
    }
    
    func checkAccount(email: String, pass: String, rePass: String) {
        
        var emailCheck = false
        
        if email == "" || pass == "" || rePass == "" {
            self.error = "다시 기입해주세요!"
            return
        }
        
        if pass.count < 6 {
            self.error = "비밀번호는 최소 6자 이상이어야 합니다."
            return
        }
        
        for i in email {
            
            if i == "@" {
                emailCheck = true
                break
            }
        }
        
        if emailCheck == false {
            self.error = "이메일 형식을 올바르게 기입해주세요."
            return
        }
        
        if pass != rePass {
            self.error = "비밀번호와 재입력 비밀번호가 다릅니다."
            return
        }
        
        signUp()
    }
}

