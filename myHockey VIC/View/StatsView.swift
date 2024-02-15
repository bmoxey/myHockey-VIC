//
//  StatsView.swift
//  myHockey VIC
//
//  Created by Brett Moxey on 19/1/2024.
//

import SwiftUI

struct StatsView: View {
    @ObservedObject private var teamsManager = TeamsManager()
    @State var haveData = false
    @State var players = [Player]()
    @State private var sortedByName = true
    @State private var sortedByNameValue: KeyPath<Player, String> = \Player.surname
    @State private var sortedByValue: KeyPath<Player, Int>? = nil
    @State private var sortAscending = true
    @State private var sortMode = 2
    var body: some View {
        if players.isEmpty {
            if haveData {
                CenterTextView(text: "No Data")
            } else {
                CenterTextView(text: "Loading...")
                    .onAppear {
                        Task {
                            players = await getPlayerStats(teamsManager: teamsManager)
                            try? await Task.sleep(nanoseconds: 50_000_000)
                            haveData = true
                        }
                    }
            }
        } else {
            List {
                DetailHeaderStatsView(sortMode: $sortMode, sortAscending: $sortAscending, sortedByName: $sortedByName, sortedByNameValue: $sortedByNameValue, sortedByValue: $sortedByValue)
                    .listRowBackground(Color("DarkColor"))
                ForEach(players.sorted(by: sortDescriptor)) { player in
//                    NavigationLink(destination: PlayerStatsView(myTeam: currentTeam.teamName, myTeamID: currentTeam.teamID, myCompID: currentTeam.compID,  player: player)) {
                        DetailStatsView(player: player)
//                    }
                    .listRowBackground(Color.white)
                }
            }
            .scrollContentBackground(.hidden)
        }
    }
    private var sortDescriptor: (Player, Player) -> Bool {
        let ascending = sortAscending
        if let sortedByValue = sortedByValue {
            return { (player1, player2) in
                if ascending {
                    return player1[keyPath: sortedByValue] < player2[keyPath: sortedByValue]
                } else {
                    return player1[keyPath: sortedByValue] > player2[keyPath: sortedByValue]
                }
            }
        } else if sortedByName {
            return { (player1, player2) in
                if ascending {
                    return player1[keyPath: sortedByNameValue] < player2[keyPath: sortedByNameValue]
                } else {
                    return player1[keyPath: sortedByNameValue] > player2[keyPath: sortedByNameValue]
                }
            }
        } else {
            return { _, _ in true }
        }

    }
 
}

#Preview {
    StatsView()
}
