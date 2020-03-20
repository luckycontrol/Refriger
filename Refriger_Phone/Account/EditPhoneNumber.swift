//
//  EditPhoneNumber.swift
//  Refriger
//
//  Created by 조종운 on 2020/03/17.
//  Copyright © 2020 조종운. All rights reserved.
//

import SwiftUI

struct EditPhoneNumber: View {
    
    @State var phoneNumber: String = ""
    @State var authorizedNumber: String = ""
    
    var body: some View {
        VStack {
            VStack(spacing: 10) {
                
                Text("휴대전화번호 인증").font(.system(size: 24, weight: .bold))
                Text("인증받으신 전화번호가 저장됩니다.").foregroundColor(.gray).opacity(0.8)
                    .padding(.bottom, 15)
                
                HStack {
                    ZStack {
                        Rectangle()
                            .frame(width: 300, height: 50)
                            .foregroundColor(.white)
                            .border(Color.black)
                        
                        TextField("'-'을 제외하고 입력해주세요.", text: $phoneNumber)
                            .padding(.leading, 15)
                    }
                    Spacer()
                    ZStack {
                        Rectangle()
                            .frame(width: 70, height: 50)
                            .foregroundColor(.white)
                            .border(Color.black)
                        
                        Text("인증").fontWeight(.semibold)
                    }
                }
                
                ZStack {
                    Rectangle()
                        .frame(height: 50)
                        .foregroundColor(.white)
                        .border(Color.black)
                    
                    TextField("인증번호를 입력해주세요.", text: $authorizedNumber)
                        .padding(.leading, 15)
                }
                Spacer()
            }
            .padding(.top, 30)
            .padding(.horizontal, 15)
        }.background(Color("MartBackground"))
    }
}

