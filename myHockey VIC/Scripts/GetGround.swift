//
//  GetGround.swift
//  myHockey VIC
//
//  Created by Brett Moxey on 20/1/2024.
//

import Foundation

func getGround(fixture: Fixture) async -> String {
    var address: String = ""
    var lines: [String] = []
    lines = GetUrl(url: "\(url)game/\(fixture.gameID)")
    for i in 0 ..< lines.count {
        if lines[i] == "Venue" { address = lines[i+4].trimmingCharacters(in: .whitespacesAndNewlines) }
    }
    return address
}
