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
        VStack(spacing: 10) {
            HStack {
                ZStack {
                    Rectangle()
                        .frame(width: 300, height: 50)
                        .foregroundColor(.white)
                        .border(Color.black)
                    
                    TextField("'-'을 제외하고 입력해주세요.", text: $phoneNumber)
                }
                
                ZStack {
                    Rectangle()
                        .frame(width: 70, height: 50)
                        .foregroundColor(.white)
                        .border(Color.black)
                    
                    Text("인증번호 요청")
                }
            }
            
            ZStack {
                Rectangle()
                    .frame(height: 50)
                    .foregroundColor(.white)
                    .border(Color.black)
                
                TextField("인증번호를 입력해주세요.", text: $authorizedNumber)
            }
        }
        .padding(.horizontal, 15)
    }
}

