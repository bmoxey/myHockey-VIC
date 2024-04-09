//
//  GetTeams.swift
//  myHockey VIC
//
//  Created by Brett Moxey on 19/1/2024.
//

import Foundation
func getTeams(myComp: Teams) async -> [Teams] {
    var teams: [Teams] = []
    var lines: [String] = []
    lines = GetUrl(url: "\(url)pointscore/\(myComp.compID)/\(myComp.divID)")
    for i in 0 ..< lines.count {
        if lines[i].contains("\(url)games/team/") {
            let teamID = lines[i].split(separator: "/")[5].trimmingCharacters(in: .punctuationCharacters)
            let teamName = ShortTeamName(fullName: lines[i+1])
            let image = GetImage(teamName: teamName)
            teams.append(Teams(compName: myComp.compName, compID: myComp.compID, divName: myComp.divName, divID: myComp.divID, type: myComp.type, teamName: teamName, teamID: teamID, image: image))
        }
    }
    return teams
}

func ShortTeamName(fullName: String) -> String {
    let newString = fullName.replacingOccurrences(of: " Hockey", with: "")
        .replacingOccurrences(of: " Club", with: "")
        .replacingOccurrences(of: " Association", with: "")
        .replacingOccurrences(of: " Sports INC", with: "")
        .replacingOccurrences(of: " Section", with: "")
        .replacingOccurrences(of: " United", with: " Utd")
        .replacingOccurrences(of: "Hockey ", with: "")
        .replacingOccurrences(of: "University", with: "Uni")
        .replacingOccurrences(of: "Eastern Christian Organisation (ECHO)", with: "ECHO")
        .replacingOccurrences(of: "Melbourne High School Old Boys", with: "MHSOB")
        .replacingOccurrences(of: "Greater ", with: "")
        .replacingOccurrences(of: "St Bede's", with: "St. Bede's")
        .replacingOccurrences(of: "Khalsas", with: "Khalsa")
    return newString
}


func ShortDivName(fullName: String) -> String {
    var newString = fullName.replacingOccurrences(of: "GAME Clothing ", with: "")
    if let firstFourDigits = Int(newString.prefix(4)), firstFourDigits > 1000 { newString.removeFirst(4) }
    if let lastFourDigits = Int(newString.suffix(4)), lastFourDigits > 1000 { newString.removeLast(4) }
    newString = newString.trimmingCharacters(in: .whitespaces)
        .trimmingCharacters(in: .punctuationCharacters)
        .trimmingCharacters(in: .whitespaces)
    return newString
}
