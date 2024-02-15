//
//  GetFixtures.swift
//  myHockey VIC
//
//  Created by Brett Moxey on 20/1/2024.
//

import Foundation

@MainActor
func getFixtures(teamsManager: TeamsManager) async -> [Fixture] {
    teamsManager.loadTeams()
    try? await Task.sleep(nanoseconds: 200_000_000)
    var fixtures: [Fixture] = []
    var myFixture: Fixture = Fixture()

    var lines: [String] = []
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = " E dd MMM yyyy HH:mm "
    myFixture.myTeam = teamsManager.currentTeam.teamName
    lines = GetUrl(url: "\(url)teams/\(teamsManager.currentTeam.compID)/&t=\(teamsManager.currentTeam.teamID)")
    for i in 0 ..< lines.count - 2 {
        if let dateTime = dateFormatter.date(from: lines[i] + " " + lines[i+2]) {
            myFixture.date = dateTime
            myFixture.roundNo = lines[i-4]
        }
        if lines[i].contains("\(url)venues/") {
            myFixture.venue = lines[i+1]
            myFixture.field = lines[i+5]
        }
        if lines[i] == "Playing" { myFixture.status = "Playing" }
        if lines[i] == "Played" { myFixture.status = "Played" }
        if lines[i].contains("have a BYE.") {
            myFixture.status = "Have a BYE"
            myFixture.result = "BYE"
            myFixture.opponent = "Nobody"
        }
        if lines[i].contains("\(url)teams/") { myFixture.opponent = ShortTeamName(fullName: lines[i+1]) }
        if lines[i] == "Draw" { myFixture.result = "Draw" }
        if lines[i] == "Win" { myFixture.result = "Win" }
        if lines[i] == "Loss" { myFixture.result = "Loss" }
        if lines[i].contains("\(url)game/") {
            myFixture.gameID = String(String(lines[i]).split(separator: "/")[3])
            myFixture.id = UUID()
            if myFixture.result == "" && myFixture.status == "Played" {myFixture.result = "No Results"}
            fixtures.append(myFixture)
            myFixture = Fixture()
            myFixture.myTeam = teamsManager.currentTeam.teamName
        }
    }

    return fixtures
}
