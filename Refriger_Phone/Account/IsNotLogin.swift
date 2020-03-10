//
//  IsNotLogin.swift
//  refriger
//
//  Created by 조종운 on 2020/01/31.
//  Copyright © 2020 조종운. All rights reserved.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct IsNotLogin: View {
    
    @EnvironmentObject var session: SessionStore
    
    @ObservedObject var viewDatas: ViewDatas
    
    @State var email: String = ""
    @State var password: String = ""
    @State var error: String = ""
    
    let db = Firestore.firestore().collection("users")
    
    var body: some View {
        
        VStack {
            
            HStack(spacing: 10) {
                Image("mart")
                Text("Cho Mart")
                    .font(.system(size: 26, weight: .bold))
            }
            
            Spacer()
            
            VStack(spacing: 20) {
                
                InputBox(secure: false, image: "person", placeholder: "이메일을 입력하세요.", text: $email)
                
                InputBox(secure: true, image: "lock.fill", placeholder: "비밀번호를 입력하세요.", text: $password)
                
                Text(error)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.red)
                    .padding(.horizontal)
            }
            .padding(.horizontal, 50)
            .padding(.bottom, 40)
            
            // 로그인 버튼
            Button(action: {
                self.checkAccount(id: self.email, pass: self.password)
            }) {
                
                HStack {
                    
                    Text("로그인")
                        .font(.system(size: 18))
                        .foregroundColor(.white)
                }
                .frame(width: 300, height: 50)
                .background((LinearGradient(gradient: Gradient(colors: [Color("purple"), Color("pink")]), startPoint: .topLeading, endPoint: .bottomTrailing)))
                .clipShape(RoundedRectangle(cornerRadius: 5))
                .shadow(radius: 5)
            }
            
            Spacer()
            
            NavigationLink(destination: CreateAccount(viewDatas: viewDatas)) {
                
                HStack(spacing: 10) {
                    
                    Text("계정이 없으신가요?")
                    
                    Text("계정생성")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.blue)
                }
            }.padding(.bottom, 10)
            
        }
        .padding(.top, 40)
    }
    
    func signIn() {
        session.signIn(email: email, password: password) { (result, error) in
            if error == nil {
                self.db.document(self.email).getDocument { (document, err) in
                    if let document = document, document.exists {
                        self.viewDatas.email = self.email
                        self.viewDatas.name = String(describing: document.data()!["name"]!)
                        self.email = ""
                        self.password = ""
                        self.viewDatas.login = true
                    } else { print("Document dose not exist")}
                }
                
            } else {
                self.error = "입력하신 계정이 올바르지 않습니다."
            }
        }
    }
    
    func checkAccount(id: String, pass: String) {
        
        var check: Bool = false
        
        if id == "" || pass == "" {
            
            self.error = "아이디 혹은 비밀번호를 입력하지 않으셨습니다."
            return
        }
        
        for c in id {
            if c == "@" {
                check = true
                break
            }
        }
        
        if check == false {
            self.error = "이메일 형식이 바르지 않습니다."
            return
            
        } else {
            signIn()
        }
    }
}
