//
//  LadderView.swift
//  myHockey VIC
//
//  Created by Brett Moxey on 19/1/2024.
//

import SwiftUI

struct LadderView: View {
    @ObservedObject private var teamsManager = TeamsManager()
    @State var haveData = false
    @State var ladder = [LadderItem]()
    var body: some View {
        if ladder.isEmpty {
            if haveData {
                CenterTextView(text: "No Data")
            } else {
                CenterTextView(text: "Loading...")
                    .onAppear {
                        Task {
                            ladder = await getLadder(teamsManager: teamsManager)
                            try? await Task.sleep(nanoseconds: 50_000_000)
                            haveData = true
                        }
                    }
            }
        } else {
                List {
                    DetailLadderHeaderView()
                        .listRowBackground(Color("DarkColor"))
                    ForEach(ladder.indices, id: \.self) { index in
                        let item = ladder[index]
                        DetailLadderView(myTeam: teamsManager.currentTeam.teamName, item: item)
                        .listRowBackground(Color.white)
                        .listRowSeparatorTint( item.pos == 4 ? Color("DarkColor") : Color(UIColor.separator), edges: .all)
                        .listRowSeparator(item.pos == 4 ? .visible : .automatic, edges: .all)
                    
                    }
                }
                .scrollContentBackground(.hidden)
                .refreshable {
                    Task {
                        ladder = await getLadder(teamsManager: teamsManager)
                        haveData = true
                    }
                }
            }
        }
    }

#Preview {
    LadderView()
}
