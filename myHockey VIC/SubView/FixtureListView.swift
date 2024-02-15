//
//  FixtureListView.swift
//  myHockey VIC
//
//  Created by Brett Moxey on 24/1/2024.
//

import SwiftUI

struct FixtureListView: View {
    @Binding var fixtures: [Fixture]
    @Binding var currentFixture: Fixture?
    var body: some View {
        HStack {
            Spacer()
            if currentFixture != fixtures.first {
                Button {
                    withAnimation {
                        guard let currentFixture, let index = fixtures.firstIndex(of: currentFixture) ,
                              index > 0 else { return }
                        self.currentFixture = fixtures[index - 1]
                    }
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(Color("AccentColor"))
                        .font(Font.system(size: 17, weight: .semibold))
                }
            } else {
                Image(systemName: "chevron.left")
                    .foregroundStyle(Color("LightColor"))
                    .font(Font.system(size: 17, weight: .semibold))
            }
            Spacer()
            ForEach(fixtures.indices, id:\.self) {index in
                let isCurrent = fixtures[index].roundNo == currentFixture?.roundNo ?? "1"
                let col = getColor(result: fixtures[index].result)
                Image(systemName: getSymbol(result: fixtures[index].result))
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(isCurrent ? col : Color(.black), isCurrent ? Color(.black) : col)
                    .scaleEffect(isCurrent ? 1.2 : 0.8)
                    .padding(.all, -5)
                    .onTapGesture {
                        withAnimation {
                            currentFixture = fixtures[index]
                        }
                    }
            }
            Spacer()
            if currentFixture != fixtures.last {
                Button {
                    withAnimation {
                        guard let currentFixture, let index = fixtures.firstIndex(of: currentFixture),
                              index < fixtures.count - 1 else { return }
                        self.currentFixture = fixtures[index + 1]
                    }
                } label: {
                    Image(systemName: "chevron.right")
                        .foregroundStyle(Color("AccentColor"))
                        .font(Font.system(size: 17, weight: .semibold))
                }
            } else {
                Image(systemName: "chevron.right")
                    .foregroundStyle(Color("LightColor"))
                    .font(Font.system(size: 17, weight: .semibold))
            }
            Spacer()
        }
        .padding(.bottom, 0)
        .background(Color.white)
        .padding(.top, -8)
    }
}

#Preview {
    FixtureListView(fixtures: .constant([]), currentFixture: .constant(Fixture()))
}
