//
//  RoundView.swift
//  myHockey VIC
//
//  Created by Brett Moxey on 19/1/2024.
//

import SwiftUI

struct RoundView: View {
    @ObservedObject private var teamsManager = TeamsManager()
    @State private var rounds: [Rounds] = []
    @State private var haveData = false
    @State private var myRound: [Round] = []
    @State var currentRound: Rounds?
    @State var searchTeam: String = ""
    var body: some View {
        VStack {
            if rounds.isEmpty {
                if haveData {
                    CenterTextView(text: "No Data")
                } else {
                    CenterTextView(text: "Loading...")
                    .onAppear {
                        Task {
                            rounds = await getRounds(teamsManager: teamsManager)
                            try? await Task.sleep(nanoseconds: 50_000_000)
                            let count = rounds.filter { $0.lastdate < Date() }.count
                            print(count)
                            scrollToElement(index: count)
                            if count > 0 {
                                currentRound = rounds[count-1]
                            }
                            haveData = true
                        }
                    }
                }
            } else {
                                RoundSelectionView(rounds: $rounds, currentRound: $currentRound)
                                RoundListView(rounds: $rounds, currentRound: $currentRound)
                
                List {
                    //                if currentRound?.result == "BYE" {
                    //                    BYEFixtureView(fixture: $currentFixture)
                    //                } else {
                    //                    if currentFixture?.status == "Playing" {
                    //                        UpcomingFixtureView(fixture: $currentFixture)
                    //                        GroundView(fixture: $currentFixture, address: $address)
                    //                    } else {
                    //                        if myRound.homeTeam != "" {
                    //                            RoundSummaryView(round: $myRound)
                    //                            PlayersView(searchTeam: myRound.myTeam, myRound: $myRound, players: $myPlayers)
                    //                        }
                    //                    }
                    //                }
                }
                .scrollContentBackground(.hidden)
            }
        }
        .onChange(of: currentRound, {
            Task() {
                try await Task.sleep(nanoseconds: 100_000_000)
                if currentRound?.result != "BYE" {
                    myRound = await getRound(currentRound: currentRound!)
                }
            }
        })
    }
    func scrollToElement(index: Int) {
            guard index < rounds.count else { return }
            DispatchQueue.main.async {
                currentRound = rounds[index]
            }
        }
}

#Preview {
    RoundView()
}
