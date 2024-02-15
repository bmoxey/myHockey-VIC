//
//  GetPlayerStats.swift
//  myHockey VIC
//
//  Created by Brett Moxey on 8/2/2024.
//

import Foundation

@MainActor
func getPlayerStats(teamsManager: TeamsManager) async -> [Player] {
    teamsManager.loadTeams()
    var myPlayer = Player()
    var players = [Player]()
    var lines: [String] = []
    var fillins: Bool = false
    lines = GetUrl(url: "\(url)teams-stats/" + teamsManager.currentTeam.compID + "/&t=" + teamsManager.currentTeam.teamID)
    for i in 0 ..< lines.count {
        if lines[i].contains("Fill ins") { fillins = true }
        if lines[i].contains("\(url)statistics/") {
            myPlayer.id = UUID()
            myPlayer.statsLink = String(lines[i].split(separator: "\"")[1])
            myPlayer.fillin = fillins
            myPlayer.name = ""
            myPlayer.surname = ""
            myPlayer.captain = false
            (myPlayer.name, myPlayer.surname, myPlayer.captain) = FixName(fullname: lines[i+1].capitalized.trimmingCharacters(in: CharacterSet.letters.inverted))
            myPlayer.numberGames = Int(lines[i+7]) ?? 0
            myPlayer.goals = Int(lines[i+11]) ?? 0
            myPlayer.greenCards = Int(lines[i+15]) ?? 0
            myPlayer.yellowCards = Int(lines[i+19]) ?? 0
            myPlayer.redCards = Int(lines[i+23]) ?? 0
            myPlayer.goalie = Int(lines[i+27]) ?? 0
            players.append(myPlayer)
            fillins = false
        }
    }
    return players
}
