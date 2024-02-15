//
//  PlayersView.swift
//  myHockey VIC
//
//  Created by Brett Moxey on 20/1/2024.
//

import SwiftUI

struct PlayersView: View {
    @State var searchTeam: String
    @Binding var myRound: Rounds
    @Binding var players: [Player]

    var body: some View {
        Section() {
            HStack {
                Spacer()
                Text("Players")
                Spacer()
            }
            .listRowBackground(Color("DarkColor"))
            .foregroundStyle(Color("LightColor"))
            Picker("Team:", selection: $searchTeam) {
                Text(myRound.homeTeam)
                    .tag(ShortTeamName(fullName: myRound.homeTeam))
                Text(myRound.awayTeam)
                    .tag(ShortTeamName(fullName: myRound.awayTeam))
            }
            .tint(Color("AccentColor"))
            .foregroundColor(Color("LightColor"))
            .pickerStyle(SegmentedPickerStyle())
            .listRowBackground(Color("DarkColor").opacity(0.8))
            ForEach(players, id:\.id) {player in
                if player.team == searchTeam {
                    PlayerView(player: player)
                }
            }
        }
        .onChange(of: myRound) {
            searchTeam = myRound.myTeam
        }
    }
}

#Preview {
    PlayersView(searchTeam: "", myRound: .constant(Rounds()), players: .constant([]))
}
