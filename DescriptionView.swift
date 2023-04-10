//
//  DescriptionView.swift
//  AIKeyboard
//
//  Created by Asami Doi on 2023/04/09.
//

import SwiftUI

struct DescriptionView: View {
    @State private var pageNumber = 0
    @State private var shouldMoveToMainPage = false
    
    private func getSuffix() -> String {
        if pageNumber == 1 {
            return "_blue"
        } else if pageNumber == 2 {
            return "_yellow"
        }
        return "_pink"
    }
    
    private func incrementPageNumber() {
        if pageNumber > 2 {
            pageNumber = 0
            shouldMoveToMainPage = true
        } else {
            pageNumber += 1
        }
    }
    
    private func getDescriptionText() -> String {
        if pageNumber == 0 {
            return "キーボードの追加とフルアクセスを許可しよう！"
        } else if pageNumber == 1 {
            return "いつものように文章を打ってください！"
        } else if pageNumber == 2 {
            return "打った文字を選択してください！"
        } else if pageNumber == 3 {
            return "AIがあなたのテキストをアップデート！"
        }
        return ""
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image("background" + getSuffix())
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                GeometryReader { geo in
                    VStack (alignment: .leading) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.white)
                                .frame(width: geo.size.width * 0.8, height: geo.size.height * 0.6, alignment: .center)
                                .opacity(0.7)
                            VStack (spacing: 40) {
                                Image("description" + String(pageNumber))
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: geo.size.width * 0.65, alignment: .center)
                                Text(getDescriptionText())
                                    .foregroundColor(.black)
                                Button(action: {
                                    incrementPageNumber()
                                }) {
                                    ZStack{
                                        Image("btn" + getSuffix())
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: geo.size.width * 0.7, alignment: .center)
                                        Text(pageNumber == 3 ? "メインページへ" : "次へ")
                                            .foregroundColor(.black)
                                            .font(.system(size: 20))
                                    }
                                }.navigationDestination(isPresented: $shouldMoveToMainPage) {
                                    ContentView().navigationBarBackButtonHidden(true)
                                }.navigationBarBackButtonHidden(true)
                                    .navigationBarHidden(true)
                            }.frame(width: geo.size.width * 0.7)
                        }
                    }.frame(maxWidth: .infinity, maxHeight: .infinity)
                        .edgesIgnoringSafeArea(.all)
                }
            }
        }.navigationBarBackButtonHidden(true).navigationBarHidden(true)
    }
}

struct DescriptionView_Previews: PreviewProvider {
    static var previews: some View {
        DescriptionView()
    }
}
