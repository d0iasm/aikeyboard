//
//  KeyboardView.swift
//  AIKeyboard
//
//  Created by Asami Doi on 2023/04/08.
//

import SwiftUI

struct KeyboardView: View {
    var body: some View {
        VStack (
            alignment: .leading,
            spacing: 10
        ) {
            HStack () {
                UIButton(primaryAction: nil)
            }
            HStack () {
            }
        }
    }
}

struct KeyboardView_Previews: PreviewProvider {
    static var previews: some View {
        KeyboardView()
    }
}
