//
//  General.swift
//  myHockey VIC
//
//  Created by Brett Moxey on 19/1/2024.
//

import Foundation
import SwiftUI

func GetImage(teamName: String) -> String {
    var image: String = ""
    if teamName == "AppLogo" {image = teamName}
    if teamName == "Nobody" {image = "AppLogo"}
    for club in clubs {
        if teamName.contains(club.clubName) {
            image = club.clubName
        }
        for other in club.otherNames ?? [] {
            if teamName.contains(other) {
                image = club.clubName
            }
        }
    }
    return image
}

func GetScores(scores: String, seperator: String) -> (String, String) {
    var homeScore = ""
    var awayScore = ""
    if scores.contains(seperator) {
        let myScores = scores.components(separatedBy: seperator)
        homeScore = myScores[0].trimmingCharacters(in: .whitespaces)
        awayScore = myScores[1].trimmingCharacters(in: .whitespaces)
    }
    return (homeScore, awayScore)
}

func GetHomeTeam(result: String, homeGoals: String, awayGoals: String, myTeam: String, opponent: String, rounds: [Round], venue: String) -> (String, String) {
    var homeTeam = myTeam
    var awayTeam = ""
    if result == "Win" {
        if Int(homeGoals) ?? 0 > Int(awayGoals) ?? 0 {
            homeTeam = myTeam
            awayTeam = opponent
        } else {
            homeTeam = opponent
            awayTeam = myTeam
        }
    }
    if result == "Loss" {
        if Int(homeGoals) ?? 0 > Int(awayGoals) ?? 0 {
            homeTeam = opponent
            awayTeam = myTeam
        } else {
            homeTeam = myTeam
            awayTeam = opponent
        }
    }
    if result == "Draw" {
        let venueFrequency = rounds.reduce(into: [:]) { counts, round in
            counts[round.venue, default: 0] += 1
        }
        if let mostCommonVenue = venueFrequency.max(by: { $0.value < $1.value })?.key {
            if venue == mostCommonVenue {
                homeTeam = myTeam
                awayTeam = opponent
            } else {
                homeTeam = opponent
                awayTeam = myTeam
            }
        } else {
            homeTeam = opponent
            awayTeam = myTeam
        }
    }
    return (homeTeam, awayTeam)
}

func weekDatesBetween(lastDate: Date, endDate: Date) -> [Date] {
    var dates: [Date] = []
    var currentDate = Calendar.current.date(byAdding: .day, value: 10, to: lastDate)!
    while currentDate <= endDate {
        dates.append(Calendar.current.date(byAdding: .day, value: -3, to: currentDate)!)
        currentDate = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: currentDate)!
    }

    return dates
}

func getColor(result: String) -> Color {
    var col: Color
    col = Color(UIColor.lightGray)
    if result == "Win" { col = Color.green }
    if result == "Loss" { col = Color.red }
    if result == "Draw" { col = Color.orange }
    if result == "No Game" { col = Color(UIColor.lightGray) }
    if result == "BYE" { col = Color.cyan }
    return col
}

func getSymbol(result: String) -> String {
    var text: String
    text = "smallcircle.filled.circle.fill"
    if result == "Win" { text = "checkmark.circle.fill" }
    if result == "Loss" { text = "xmark.circle.fill" }
    if result == "Draw" { text = "equal.circle.fill" }
    if result == "No Game" { text = "circle.fill" }
    if result == "BYE" { text = "hand.raised.circle.fill" }
    return text
}

func getDay(date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "d MMM"
    return dateFormatter.string(from: date)
}

func FixName(fullname: String) -> (String, String, Bool) {
    var myCap = false
    var myName = fullname
    if myName.contains(" (Captain)") {
        myCap = true
        myName = myName.replacingOccurrences(of: " (Captain)", with: "")
    }
    let mybits = myName.split(separator: ",")
    var surname = ""
    if mybits.count > 0 {
        surname = mybits[0].trimmingCharacters(in: .whitespaces).capitalized
        if surname.contains("'") {
            let mybits1 = surname.split(separator: "'")
            surname = mybits1[0].capitalized + "'" + mybits1[1].capitalized
        }
        let name = surname
        let surname = name.count >= 3 && name.lowercased().hasPrefix("mc") ? String(name.prefix(2)) + name[name.index(name.startIndex, offsetBy: 2)].uppercased() + String(name.suffix(from: name.index(after: name.index(name.startIndex, offsetBy: 2)))) : name
        if mybits.count > 1 {
            myName = mybits[1].trimmingCharacters(in: .whitespaces).capitalized + " " + surname
        }
    }
    return(myName, surname, myCap)
}
