//
//  RoundListView.swift
//  myHockey VIC
//
//  Created by Brett Moxey on 12/3/2024.
//

import SwiftUI

struct RoundListView: View {
    @Binding var rounds: [Rounds]
    @Binding var currentRound: Rounds?
    var body: some View {
        HStack {
            Spacer()
            if currentRound != rounds.first {
                Button {
                    withAnimation {
                        guard let currentRound, let index = rounds.firstIndex(of: currentRound) ,
                              index > 0 else { return }
                        self.currentRound = rounds[index - 1]
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
            ForEach(rounds.indices, id:\.self) {index in
                let isCurrent = rounds[index].roundNo == currentRound?.roundNo ?? "1"
                let num = rounds[index].roundNum
                Image(systemName: isCurrent ? "\(num).circle.fill" : "\(num).circle")
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(isCurrent ? Color(.white) : Color(.black), isCurrent ? Color(.black) : Color(.white))
                    .scaleEffect(isCurrent ? 1.2 : 0.8)
                    .padding(.all, -5)
                    .onTapGesture {
                        withAnimation {
                            currentRound = rounds[index]
                        }
                    }
            }
            Spacer()
            if currentRound != rounds.last {
                Button {
                    withAnimation {
                        guard let currentRound, let index = rounds.firstIndex(of: currentRound),
                              index < rounds.count - 1 else { return }
                        self.currentRound = rounds[index + 1]
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
    RoundListView(rounds: .constant([]), currentRound: .constant(Rounds()))
}
