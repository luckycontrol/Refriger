//
//  RefrigerData.swift
//  Refriger
//
//  Created by 조종운 on 2020/02/07.
//  Copyright © 2020 조종운. All rights reserved.
//

import Foundation
import SwiftUI

class ViewDatas: ObservableObject {
    
    @Published var email: String = "이메일"
    @Published var name: String = "회원"
    @Published var login: Bool = false
    
    @Published var category: String = "과일"
    @Published var foodName: String = "딸기 / 블루베리"
}

class SelfAddData: ObservableObject {
    @Published var selfAddDataList: [selfAddData] = [selfAddData()]
}

class selfAddData: Identifiable {
    
    var id: Int = 0
    @Published var foodType: String = ""
    @Published var foodName: String = ""
    @Published var expiration: Date = Date()
}

struct InputBox: View {
    
    var secure: Bool
    var image: String
    var placeholder: String
    @Binding var text: String
    
    var body: some View {
        
        VStack {
            
            HStack {
                
                if secure {
                    
                    Image(systemName: image)
                    SecureField(placeholder, text: $text)
                } else {
                    
                    Image(systemName: image)
                    TextField(placeholder, text: $text)
                }
            }
            Divider()
        }
    }
}

struct food: Identifiable {
    let id: Int
    let foodType: String
    let row: [row]
}

struct row: Identifiable {
    let id: Int
    let foodName: String
    let foodCategory: String
    let image: String
    let price: String
}

var fruit = [
    food(
        id: 0,
        foodType: "딸기 / 블루베리",
        row: [
            row(id: 0, foodName: "[국내산] 무 농약 생 블루베리", foodCategory: "과일", image: "[국내산] 무 농약 생 블루베리", price: "22,000"),
            row(id: 1, foodName: "[굿모닝 딸기] 설향 딸기 2kg", foodCategory: "과일", image: "[굿모닝 딸기] 설향 딸기 2kg", price: "36,900"),
            row(id: 2, foodName: "[칠레산] 생 블루베리", foodCategory: "과일", image: "[칠레산] 생 블루베리", price: "6,300"),
            row(id: 3, foodName: "매향 딸기", foodCategory: "과일", image: "매향 딸기", price: "21,000"),
            row(id: 4, foodName: "산청 딸기", foodCategory: "과일", image: "산청 딸기", price: "51,900"),
            row(id: 5, foodName: "커클랜드 건블루베리", foodCategory: "과일", image: "커클랜드 건블루베리", price: "12,700"),
        ]
    ),
    
    food(
        id: 1,
        foodType: "감귤 / 한라봉",
        row: [
            row(id: 0, foodName: "[산지직송] 제주 감귤", foodCategory: "과일", image: "[산지직송] 제주 감귤", price: "12,000"),
            row(id: 1, foodName: "[제주 프루츠] 하늘 농산 감귤", foodCategory: "과일", image: "[제주 프루츠] 하늘 농산 감귤", price: "21,400"),
            row(id: 2, foodName: "명품 한라봉 세트", foodCategory: "과일", image: "명품 한라봉 세트", price: "52,000"),
            row(id: 3, foodName: "제주 한라봉 3kg", foodCategory: "과일", image: "제주 한라봉 3kg", price: "42,500"),
            row(id: 4, foodName: "제주 한라봉 5kg", foodCategory: "과일", image: "제주 한라봉 5kg", price: "73,000"),
            row(id: 5, foodName: "제주감귤 5kg", foodCategory: "과일", image: "제주감귤 5kg", price: "35,000"),
        ]
    ),
    
    food(
        id: 2,
        foodType: "사과",
        row: [
            row(id: 0, foodName: "[감사선물] 사과 세트", foodCategory: "과일", image: "[감사선물] 사과 세트", price: "25,000"),
            row(id: 1, foodName: "[국내산] 990 사과", foodCategory: "과일", image: "[국내산] 990 사과", price: "5,300"),
            row(id: 2, foodName: "[국내산] 사과 4-11개입", foodCategory: "과일", image: "[국내산] 사과 4-11개입", price: "12,000"),
            row(id: 3, foodName: "당찬 사과", foodCategory: "과일", image: "당찬 사과", price: "7,900"),
            row(id: 4, foodName: "못난이 햇사과", foodCategory: "과일", image: "못난이 햇사과", price: "11,900"),
            row(id: 5, foodName: "사과 선물 세트", foodCategory: "과일", image: "사과 선물 세트", price: "27,500"),
        ]
    )
]

var vegetable = [
    food(
        id: 0,
        foodType: "고구마 / 감자",
        row: [
            row(id: 0, foodName: "[감자국] 감자", foodCategory: "채소", image: "[감자국] 감자", price: "12,000"),
            row(id: 1, foodName: "[국내산] 감자도리", foodCategory: "채소", image: "[국내산] 감자도리", price: "100,000"),
            row(id: 2, foodName: "[서울우유] 호박고구마 우유", foodCategory: "채소", image: "[서울우유] 호박고구마 우유", price: "900"),
            row(id: 3, foodName: "대왕감자 10kg", foodCategory: "채소", image: "대왕감자 10kg", price: "32,000"),
            row(id: 4, foodName: "아이스 군고구마", foodCategory: "채소", image: "아이스 군고구마", price: "9000"),
            row(id: 5, foodName: "여수 고구마", foodCategory: "채소", image: "여수 고구마", price: "14,000"),
        ]
    ),
    
    food(
        id: 1,
        foodType: "상추 / 깻잎",
        row: [
            row(id: 0, foodName: "[가락시장직송] 청상추 100g", foodCategory: "채소", image: "[가락시장직송] 청상추 100g", price: "3,200"),
            row(id: 1, foodName: "상추 100g", foodCategory: "채소", image: "상추 100g", price: "1,200"),
            row(id: 2, foodName: "우리가락 깻잎", foodCategory: "채소", image: "우리가락 깻잎", price: "3,800"),
            row(id: 3, foodName: "유기농 청상추 1kg", foodCategory: "채소", image: "유기농 청상추 1kg", price: "12,900"),
            row(id: 4, foodName: "펴진깻잎 5kg", foodCategory: "채소", image: "펴진깻잎 5kg", price: "51,000"),
            row(id: 5, foodName: "쌈싸먹어", foodCategory: "채소", image: "쌈싸먹어", price: "1"),
        ]
    ),
    
    food(
        id: 2,
        foodType: "시금치 / 부추",
        row: [
            row(id: 0, foodName: "시금치 200g", foodCategory: "채소", image: "시금치 200g", price: "4,500"),
            row(id: 1, foodName: "냉동 시금치 1kg", foodCategory: "채소", image: "냉동 시금치 1kg", price: "3,900"),
            row(id: 2, foodName: "시금치 4kg 1박스 두리반농산", foodCategory: "채소", image: "시금치 4kg 1박스 두리반농산", price: "17,000"),
            row(id: 3, foodName: "부추 200g", foodCategory: "채소", image: "부추 200g", price: "3,000"),
            row(id: 4, foodName: "[국내산] 영양부추 특 1단 250g 내외", foodCategory: "채소", image: "[국내산] 영양부추 특 1단 250g 내외", price: "8,190"),
            row(id: 5, foodName: "총각네 부추 1단", foodCategory: "채소", image: "총각네 부추 1단", price: "3,750"),
        ]
    )
]

var meat = [
    food(
        id: 0,
        foodType: "소고기",
        row: [
            row(id: 0, foodName: "[국내산] 소고기 국거리용 200g", foodCategory: "육류", image: "[국내산] 소고기 국거리용 200g", price: "7,700"),
            row(id: 1, foodName: "[냉동] 설상목장 무항생제 한우 샤브샤브용 300g", foodCategory: "육류", image: "[냉동] 설상목장 무항생제 한우 샤브샤브용 300g", price: "12,460"),
            row(id: 2, foodName: "국내산 소고기 육전용 200g", foodCategory: "육류", image: "국내산 소고기 육전용 200g", price: "8,220"),
            row(id: 3, foodName: "[피코크] 한우 곰 탕 500g", foodCategory: "육류", image: "[피코크] 한우 곰 탕 500g", price: "3,180"),
            row(id: 4, foodName: "[피코크] 한우사골육수 1kg", foodCategory: "육류", image: "[피코크] 한우사골육수 1kg", price: "5,980"),
            row(id: 5, foodName: "횡성한우 불고기(팩) 100g", foodCategory: "육류", image: "횡성한우 불고기(팩) 100g", price: "6,900"),
        ]
    ),
    
    food(
        id: 1,
        foodType: "돼지고기",
        row: [
            row(id: 0, foodName: "국내산 칼집 삼겹살 100g", foodCategory: "육류", image: "국내산 칼집 삼겹살 100g", price: "1,780"),
            row(id: 1, foodName: "[설상목장] 무항생제 한돈 대패삼겹살300g", foodCategory: "육류", image: "[설상목장] 무항생제 한돈 대패삼겹살300g", price: "6,930"),
            row(id: 2, foodName: "[더느림] 냉동 목심 구이용 400g", foodCategory: "육류", image: "[더느림] 냉동 목심 구이용 400g", price: "8,710"),
            row(id: 3, foodName: "[해발500포크] 냉장등심다짐육용400g", foodCategory: "육류", image: "[해발500포크] 냉장등심다짐육용400g", price: "4,130"),
            row(id: 4, foodName: "[김해축협] 한돈 삼겹살(구이용) 300g", foodCategory: "육류", image: "[김해축협] 한돈 삼겹살(구이용) 300g", price: "4,970"),
            row(id: 5, foodName: "[더느림] 냉장 칼집구이용 미박 삼겹살 400g", foodCategory: "육류", image: "[더느림] 냉장 칼집구이용 미박 삼겹살 400g", price: "9,510"),
        ]
    ),
    
    food(
        id: 2,
        foodType: "닭 / 오리고기",
        row: [
            row(id: 0, foodName: "[No Brand][노브랜드] 냉동 닭가슴살 1kg", foodCategory: "육류", image: "[No Brand][노브랜드] 냉동 닭가슴살 1kg", price: "5,980"),
            row(id: 1, foodName: "훈제오리 특별기획(600g*2):", foodCategory: "육류", image: "훈제오리 특별기획(600g*2)", price: "11,980"),
            row(id: 2, foodName: "[No Brand][노브랜드] 냉동 닭안심 1kg", foodCategory: "육류", image: "[No Brand][노브랜드] 냉동 닭안심 1kg", price: "5,980"),
            row(id: 3, foodName: "[하림] 냉장 볶음탕용 생닭 (1kg)", foodCategory: "육류", image: "[하림] 냉장 볶음탕용 생닭 (1kg)", price: "4,980"),
            row(id: 4, foodName: "★듀록 돼지고기 1kg 증정★소고기 배불특가 1.6kg", foodCategory: "육류", image: "★듀록 돼지고기 1kg 증정★소고기 배불특가 1.6kg", price: "39,600"),
            row(id: 5, foodName: "하림 춘천식 닭갈비 매운맛 500g", foodCategory: "육류", image: "하림 춘천식 닭갈비 매운맛 500g", price: "6,380"),
        ]
    )
]



