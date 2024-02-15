//
//  GetCompView.swift
//  myHockey VIC
//
//  Created by Brett Moxey on 19/1/2024.
//

import SwiftUI

struct GetCompView: View {
    @Binding var comps: [Teams]
    @Binding var myComp: Teams
    @State private var searchComp = "ALL"
    @State private var searchType = "ALL"

    var body: some View {
        let uniqueCompArray = comps.reduce(into: Set<String>()) { result, competition in result.insert(competition.compName)}.union(["ALL"]).sorted()
        let uniqueTypeArray = comps.reduce(into: Set<String>()) { result, competition in result.insert(competition.type)}.union(["ALL"]).sorted()
        Section(header: Text("Add team from competition...").foregroundStyle(Color("DarkColor"))) {
            Picker("Competition:", selection: $searchComp) {
                ForEach(uniqueCompArray, id: \.self) {
                    Text($0)
                }
            }
            .foregroundColor(Color("LightColor"))
            .tint(Color("AccentColor"))
            .pickerStyle(.menu)
            .listRowBackground(Color("DarkColor"))
            Picker("Type", selection: $searchType) {
                ForEach(uniqueTypeArray, id: \.self) {type in
                    Text(type)
                }
            }
            .foregroundColor(Color("DarkColor"))
            .tint(Color("DarkColor"))
            .pickerStyle(SegmentedPickerStyle())
            .listRowBackground(Color("LightColor"))
            ForEach(comps) { comp in
                if comp.compName == searchComp || searchComp == "ALL" {
                    if comp.type == searchType || searchType == "ALL" {
                        HStack {
                            Text(comp.type)
                            Text(comp.divName)
                                .foregroundStyle(Color("DarkColor"))
                                .onTapGesture { myComp = comp }
                        }
                        .listRowBackground(Color("LightColor"))
                    }
                }
            }
        }
    }
}

#Preview {
    GetCompView(comps: .constant([]), myComp: .constant(Teams()))
}
