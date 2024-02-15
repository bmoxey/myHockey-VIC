//
//  ContentView.swift
//  myHockey VIC
//
//  Created by Brett Moxey on 19/1/2024.
//

import SwiftUI

struct ContentView: View {
    @State var selectedIndex = 0
    @StateObject var teamsManager = TeamsManager()
    var body: some View {
        ZStack {
            VStack {
                Rectangle()
                    .frame(height: 32)
                tabItems[selectedIndex].viewName
                    .environmentObject(teamsManager)
                Rectangle()
                    .frame(height: 39)
            }
            .background(Color("DarkColor").opacity(0.2))
            GeometryReader { proxy in
                VStack {
                    HeaderView(image: "AppLogo", tabindex: selectedIndex)
                        .environmentObject(teamsManager)
                    Spacer()
                    HStack(alignment: .bottom, spacing: 0){
                        ForEach(0..<5) { (index) in
                            let tab = tabItems[index]
                            VStack(spacing: 0) {
                                Spacer()
                                Rectangle()
                                    .foregroundColor( .clear )
                                    .frame(width: 40, height: 40)
                                    .overlay(
                                        ZStack {
                                            Image(systemName: tab.imageName)
                                                .font(.system(size: 24))
                                                .symbolRenderingMode(.palette)
                                                .foregroundStyle(self.selectedIndex == index ? Color("DarkColor") : Color.gray, self.selectedIndex == index ? Color("LightColor") : Color("LightColor"))
                                        }
                                    )
                                    .background(
                                        ZStack {
                                            Text(tab.title)
                                                .font(.system(size: 10, weight: .bold))
                                                .foregroundStyle(Color("LightColor"))
                                                .opacity(self.selectedIndex == index ? 1.0 : 0.0)
                                        }.offset(CGSize(width: 0, height: 32))
                                    )
                                Rectangle()
                                    .foregroundColor(.clear)
                                    .frame(height: self.selectedIndex == index ? 26 : 5)
                            }
                            .frame(width: proxy.size.width * 0.2)
                            .contentShape( Rectangle() )
                            .onTapGesture {
                                withAnimation(.interactiveSpring(response: 0.4, dampingFraction: 0.7) ) { self.selectedIndex = index }
                            }
                        }
                    }
                    .background(
                        Rectangle()
                            .frame(height: 24 + 49 + 40)
                            .overlay(
                                Circle()
                                    .foregroundColor(Color("AccentColor"))
                                    .frame(width: 40, height: 40)
                                    .offset(CGSize(width: CGFloat(self.selectedIndex - 2) * (proxy.size.width * 0.2), height: -29))
                            )
                            .foregroundColor(Color("DarkColor"))
                            .offset(CGSize(width: 0, height: 20))
                            .mask(
                                VStack(spacing: 0) {
                                    TopFrameView()
                                        .frame(width: 75, height: 24)
                                        .offset(CGSize(width: CGFloat(self.selectedIndex - 2) * (proxy.size.width * 0.2), height: 0))
                                    Rectangle()
                                        .frame(height: 49 + 40)
                                }.offset(CGSize(width: 0, height: 20))
                            ).shadow(color: Color("DarkColor") , radius: 10, x: 0, y: 0)
                    ).frame(height: 24 + 49)
                }
            }.ignoresSafeArea(edges: [.trailing, .leading])
        }
        .background(Color("LightColor"))
        .onAppear {
            teamsManager.saveTeams()
        }
    }
}

#Preview {
    ContentView()
}
