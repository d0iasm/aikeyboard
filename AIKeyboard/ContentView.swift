//
//  ContentView.swift
//  AIKeyboard
//
//  Created by Asami Doi on 2023/04/08.
//

import SwiftUI
import CoreData

struct ContentView: View {
    //@Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        NavigationView {
            ZStack {
                Image("background")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                GeometryReader { geo in
                    VStack (alignment: .leading) {
                        HStack {
                            Image("title").resizable()
                                .scaledToFit()
                                .frame(width: geo.size.width * 0.35)
                            Spacer()
                        }.frame(width: geo.size.width * 0.7)
                            .toolbar {
                                ToolbarItem(placement: .navigationBarTrailing) {
                                    HStack(spacing: 0) {
                                        Link("Privacy", destination: URL(string: "https://aikeybord.studio.site/policy")!)
                                            .font(.headline)
                                        Link("Terms", destination: URL(string: "https://aikeybord.studio.site/")!)
                                            .font(.headline)
                                    }
                                }
                            }
                        ZStack{
                            Image("background_howtouse")
                                .resizable()
                                .scaledToFit()
                                .frame(width: geo.size.width * 0.9, alignment: .center)
                            NavigationLink(destination: DescriptionView()) {
                                Text("初めての方はこちら")
                                    .foregroundColor(.white)
                                    .bold()
                                    .font(.system(size: 24))
                            }.navigationBarBackButtonHidden(true)
                        }
                        ZStack{
                            Image("bg_emoji")
                                .resizable()
                                .scaledToFit()
                                .frame(width: geo.size.width * 0.9, alignment: .center)
                            VStack (alignment: .leading,
                                    spacing: 10){
                                Text("絵文字キーボード")
                                    .foregroundColor(.black)
                                    .bold()
                                    .font(.system(size: 18))
                                Text("あなたの文章をAIが読み込んで勝手に絵文字を追加します！絵文字があるだけでチャットでの印象が大きく変わるかも！？")
                                    .font(.system(size: 14))
                                    .fixedSize(horizontal: false, vertical: true)
                                Button(action: {
                                    if let url = URL(string: UIApplication.openSettingsURLString) {
                                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                    }
                                }) {
                                    ZStack{
                                        Image("btn_pink")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: geo.size.width * 0.8, alignment: .center)
                                        Text("キーボードを追加")
                                            .foregroundColor(.black)
                                            .font(.system(size: 18))
                                    }
                                }
                            }.frame(width: geo.size.width * 0.8)
                        }
                        ZStack{
                            Image("bg_translater")
                                .resizable()
                                .scaledToFit()
                                .frame(width: geo.size.width * 0.9, alignment: .center)
                            VStack (alignment: .leading,
                                    spacing: 10){
                                Text("英語変換キーボード")
                                    .foregroundColor(.black)
                                    .bold()
                                    .font(.system(size: 18))
                                Text("もう翻訳アプリを立ち上げる必要なし！日本語で打った文章がボタン一つでネイティブの英語に変わります！")
                                    .font(.system(size: 14))
                                    .fixedSize(horizontal: false, vertical: true)
                                Button(action: {
                                    if let url = URL(string: UIApplication.openSettingsURLString) {
                                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                    }
                                }) {
                                    ZStack{
                                        Image("btn_blue")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: geo.size.width * 0.8, alignment: .center)
                                        Text("キーボードを追加")
                                            .foregroundColor(.black)
                                            .font(.system(size: 18))
                                    }
                                }
                            }.frame(width: geo.size.width * 0.8)
                        }
                        ZStack{
                            Image("bg_formatter")
                                .resizable()
                                .scaledToFit()
                                .frame(width: geo.size.width * 0.9, alignment: .center)
                            VStack (alignment: .leading,
                                    spacing: 10){
                                Text("伝わるキーボード")
                                    .foregroundColor(.black)
                                    .bold()
                                    .font(.system(size: 18))
                                Text("仕事の文章や長文をわかりやすく伝えよう！誰にでも分かりやすく、論理的に、文章を作り直します。")
                                    .font(.system(size: 14))
                                    .fixedSize(horizontal: false, vertical: true)
                                Button(action: {
                                    if let url = URL(string: UIApplication.openSettingsURLString) {
                                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                    }
                                }) {
                                    ZStack{
                                        Image("btn_yellow")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: geo.size.width * 0.8, alignment: .center)
                                        Text("キーボードを追加")
                                            .foregroundColor(.black)
                                            .font(.system(size: 18))
                                    }
                                }
                            }.frame(width: geo.size.width * 0.8)
                        }
                    }.frame(maxWidth: .infinity, maxHeight: .infinity)
                        .edgesIgnoringSafeArea(.all)
                }
            }
        }.navigationBarBackButtonHidden(true)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        //ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        ContentView()
    }
}
