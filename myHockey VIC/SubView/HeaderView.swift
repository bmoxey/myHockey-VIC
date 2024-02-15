//
//  HeaderView.swift
//  myHockey VIC
//
//  Created by Brett Moxey on 19/1/2024.
//

import SwiftUI

struct HeaderView: View {
    @EnvironmentObject private var teamsManager: TeamsManager
    var image: String
    var tabindex: Int
    
    var body: some View {
        ZStack(alignment: .bottom) {
            HStack {
                Image(systemName: tabItems[tabindex].imageName)
                    .symbolRenderingMode(.palette)
                    .font(.system(size: 30))
                    .foregroundStyle(Color("AccentColor"), Color("LightColor"))
                    .padding(.horizontal)
                VStack {
                    HStack {
                        Spacer()
                        Text(tabItems[tabindex].fulltitle)
                            .foregroundStyle(Color("LightColor"))
                            .fontWeight(.bold)
                        Spacer()
                    }
                    HStack {
                        Spacer()
                        Text(teamsManager.currentTeam.divName == "" ? "No Team Selected" : teamsManager.currentTeam.divName)
                            .foregroundStyle(Color("LightColor").opacity(0.8))
                            .font(.footnote)
                            .lineLimit(1)
                        Spacer()
                    }
                }
                Image(teamsManager.currentTeam.divName == "" ? image : teamsManager.currentTeam.image)
                    .resizable()
                    .scaledToFit()
                    .padding(.all, 1)
                    .frame(width: 40, height: 40)
                    .padding(.horizontal)
            }
            .frame(height: 50)
            .background(Color("DarkColor"))
//            Rectangle()
//                .frame(height: 3)
//                .background(Color("DarkColor"))
        }
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView(image: "AppLogo", tabindex: 1)
    }
}
