//
//  SetupView.swift
//  myHockey VIC
//
//  Created by Brett Moxey on 19/1/2024.
//

import SwiftUI

struct SetupView: View {
    @EnvironmentObject private var teamsManager: TeamsManager
    @State private var comps: [Teams] = []
    @State private var myComp: Teams = Teams()
    var body: some View {
        List{
            CurrentTeamsView()
                .environmentObject(teamsManager)
            if comps.isEmpty {
                Text("Loading...")
                    .foregroundStyle(Color("DarkColor"))
                    .listRowBackground(Color("LightColor"))
                    .task {comps = await getComps()}
            } else {
                if myComp.compName == "" {
                    GetCompView(comps: $comps, myComp: $myComp)
                } else {
                    GetTeamView(myComp: $myComp)
                        .environmentObject(teamsManager)
                }
            }
        }
        .scrollContentBackground(.hidden)
    }
}

#Preview {
    SetupView()
}
