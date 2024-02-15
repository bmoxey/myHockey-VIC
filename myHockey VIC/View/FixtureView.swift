//
//  FixtureView.swift
//  myHockey VIC
//
//  Created by Brett Moxey on 19/1/2024.
//

import SwiftUI

struct FixtureView: View {
    @ObservedObject private var teamsManager = TeamsManager()
    @State private var fixtures: [Fixture] = []
    @State private var haveData = false
    @State private var myRound: Rounds = Rounds()
    @State private var myPlayers: [Player] = []
    @State var currentFixture: Fixture?
    @State var address: String = ""
    @State var searchTeam: String = ""
    var body: some View {
        VStack {
            if fixtures.isEmpty {
                if haveData {
                    CenterTextView(text: "No Data")
                } else {
                    CenterTextView(text: "Loading...")
                    .onAppear {
                        Task {
                            fixtures = await getFixtures(teamsManager: teamsManager)
                            try? await Task.sleep(nanoseconds: 50_000_000)
                            let count = fixtures.filter { $0.date < Date() }.count
                            scrollToElement(index: count)
                            haveData = true
                        }
                    }
                }
            } else {
                FixtureSelectionView(fixtures: $fixtures, currentFixture: $currentFixture)
                FixtureListView(fixtures: $fixtures, currentFixture: $currentFixture)
            }
            List {
                if currentFixture?.result == "BYE" {
                    BYEFixtureView(fixture: $currentFixture)
                } else {
                    if currentFixture?.status == "Playing" {
                        UpcomingFixtureView(fixture: $currentFixture)
                        GroundView(fixture: $currentFixture, address: $address)
                    } else {
                        if myRound.homeTeam != "" {
                            RoundSummaryView(round: $myRound)
                            PlayersView(searchTeam: myRound.myTeam, myRound: $myRound, players: $myPlayers)
                        }
                    }
                }
            }
            .scrollContentBackground(.hidden)
        }
        .onChange(of: currentFixture, {
            Task() {
                try await Task.sleep(nanoseconds: 100_000_000)
                if currentFixture?.result != "BYE" {
                    if currentFixture?.status == "Playing" {
                        address = await getGround(fixture: currentFixture ?? Fixture())
                    } else {
                        (myRound, myPlayers) = await getGame(fixture: currentFixture ?? Fixture())
                    }
                }
            }
        })
    }
    func scrollToElement(index: Int) {
            guard index < fixtures.count else { return }
            DispatchQueue.main.async {
                currentFixture = fixtures[index]
            }
        }
}
#Preview {
    FixtureView()
}
