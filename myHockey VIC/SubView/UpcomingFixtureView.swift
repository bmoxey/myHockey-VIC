//
//  UpcomingFixtureView.swift
//  myHockey VIC
//
//  Created by Brett Moxey on 25/1/2024.
//

import SwiftUI

struct UpcomingFixtureView: View {
    @Binding var fixture: Fixture?
    @State private var timeRemaining: TimeInterval = 0
    @State private var timer: Timer?
    var body: some View {
        Section() {
            HStack {
                Spacer()
                Text("\(countdownString())")
                    .frame(alignment: .center)
                    .foregroundStyle(Color("AccentColor"))
                Spacer()
            }
            .listRowBackground(Color("DarkColor"))
            .onChange(of: fixture ) {
                timer?.invalidate()
                timer = nil
                guard let mydate = fixture?.date else { return }
                timeRemaining = mydate.timeIntervalSinceNow
                timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                    timeRemaining = mydate.timeIntervalSinceNow
                    if timeRemaining <= 0 {
                        timer?.invalidate()
                        timer = nil
                    }
                }
            }
            .onAppear {
                guard let mydate = fixture?.date else { return }
                timeRemaining = mydate.timeIntervalSinceNow
                timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                    timeRemaining = mydate.timeIntervalSinceNow
                    if timeRemaining <= 0 {
                        timer?.invalidate()
                        timer = nil
                    }
                }
            }
            .onDisappear {
                timer?.invalidate()
                timer = nil
            }
            HStack {
                Image(GetImage(teamName: fixture?.opponent ?? "AppLogo"))
                    .resizable()
                    .frame(width: 75, height: 75)
                Spacer()
                VStack {
                    Text(fixture?.opponent ?? "")
                        .multilineTextAlignment(.center)
                    Text("")
                    Text("@ \(fixture?.field ?? "")")
                }
                Spacer()
                DateBoxView(date: fixture?.date ?? Date(), fullDate: true)
            }
            .listRowBackground(getColor(result: fixture?.result ?? "Draw").brightness(0.9))
            .foregroundStyle(Color("DarkColor"))
        }
    }
    private func countdownString() -> String {
        let days = Int(timeRemaining) / (60 * 60 * 24)
        let hours = Int(timeRemaining) % (60 * 60 * 24) / 3600
        let minutes = Int(timeRemaining) % 3600 / 60
        let seconds = Int(timeRemaining) % 60
        if days > 0 { return String(format: "Game starts in %d days, %d hours", days, hours) }
        if hours > 0 { return String(format: "Game starts in %d hours, %d minutes", hours, minutes)}
        return String(format: "Game starts in %d minutes, %d seconds", minutes, seconds)
    }
}

#Preview {
    UpcomingFixtureView(fixture: .constant(Fixture()))
}
