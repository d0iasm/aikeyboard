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
                    VStack {
                        HStack {
                            Text("AI Keyboard")
                            Spacer()
                            Text("Privacy")
                            Text("Terms")
                            //NavigationLink(destination: Text("Second View"), tag: "Second", selection: $selection) { EmptyView() }
                            //NavigationLink(destination: Text("third View"), tag: "Second", selection: $selection) { EmptyView() }
                        }
                        Image("background_howtouse")
                            .resizable()
                            .scaledToFit()
                            .frame(width: geo.size.width * 0.9, alignment: .center)
                        RoundedRectangle(cornerRadius: 30)
                            .fill(Color.white)
                            .frame(width: geo.size.width * 0.9, height: 100, alignment: .center)
                        
                        RoundedRectangle(cornerRadius: 30)
                            .fill(Color.white)
                            .frame(width: geo.size.width * 0.9, height: 100, alignment: .center)
                        
                        RoundedRectangle(cornerRadius: 30)
                            .fill(Color.white)
                            .frame(width: geo.size.width * 0.9, height: 100, alignment: .center)
                    }.frame(maxWidth: .infinity, maxHeight: .infinity)
                     .edgesIgnoringSafeArea(.all)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        //ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        ContentView()
    }
}
