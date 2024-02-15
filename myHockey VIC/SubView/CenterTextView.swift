//
//  CenterTextView.swift
//  myHockey VIC
//
//  Created by Brett Moxey on 24/1/2024.
//

import SwiftUI

struct CenterTextView: View {
    @State var text: String
    var body: some View {
        VStack {
            Spacer()
            Text(text)
                .foregroundStyle(Color("DarkColor"))
                .font(.largeTitle)
            Spacer()
        }
    }
}

#Preview {
    CenterTextView(text: "Loading...")
}
