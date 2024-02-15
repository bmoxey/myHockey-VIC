//
//  GetGame.swift
//  myHockey VIC
//
//  Created by Brett Moxey on 27/1/2024.
//

import Foundation
func getGame(fixture: Fixture) async ->  (Rounds, [Player]) {
    try? await Task.sleep(nanoseconds: 200_000_000)
    var myRound: Rounds = Rounds()
    var players: [Player] = []
    var myPlayer: Player = Player()
    var lines: [String] = []
    var attended: Bool = false
    var scores: String = ""
    var homePlayer: Bool = false
    lines = GetUrl(url: "\(url)game/\(fixture.gameID)/")
    for i in 0 ..< lines.count {
        if lines[i].contains("\(url)teams/") {
            if myRound.homeTeam == "" {
                myRound.homeTeam = lines[i+1]
            } else {
                if myRound.awayTeam == "" {
                    myRound.awayTeam = lines[i+1]
                } else {
                    if scores == "" {
                        scores = lines[i+7]
                        (myRound.homeGoals, myRound.awayGoals) = GetScores(scores: scores, seperator: "-")
                    }
                }
            }
        }
        if lines[i].contains(" drew!") {
            scores = lines[i+4]
            (myRound.homeGoals, myRound.awayGoals) = GetScores(scores: scores, seperator: "-")
        }
        if String(lines[i]) == myRound.homeTeam { homePlayer = true }
        if String(lines[i]) == myRound.awayTeam { homePlayer = false }
        if lines[i].contains("Attended") {attended = true}
        if lines[i].contains("Did not attend") {attended = false}
        if lines[i].contains("\(url)statistics/") && attended {
            myPlayer.name = lines[i+1]
            myPlayer.goals = Int(lines[i+7]) ?? 0
            myPlayer.greenCards = Int(lines[i+11]) ?? 0
            myPlayer.yellowCards = Int(lines[i+15]) ?? 0
            myPlayer.redCards = Int(lines[i+19]) ?? 0
            if homePlayer {myPlayer.team = ShortTeamName(fullName: myRound.homeTeam)}
            else {myPlayer.team = ShortTeamName(fullName: myRound.awayTeam)}
            players.append(myPlayer)
            myPlayer = Player()
        }
    }
    myRound.homeTeam = ShortTeamName(fullName: myRound.homeTeam)
    myRound.awayTeam = ShortTeamName(fullName: myRound.awayTeam)
    myRound.myTeam = fixture.myTeam
    myRound.venue = fixture.venue
    myRound.field = fixture.field
    myRound.result = fixture.result
    myRound.date = fixture.date
    myRound.roundNo = fixture.roundNo
    return (myRound, players)
}
