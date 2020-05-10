//
//  QuestDetail.swift
//  PrototypeApp
//
//  Created by Christian From Rasmussen on 04/05/2020.
//  Copyright © 2020 Christian From. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct QuestDetail: View {
    var quest: Quest
    @Binding var show: Bool
    @Binding var active: Bool
    @Binding var activeIndex: Int
    
    var body: some View {
        ScrollView {
            VStack {
                VStack {
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 8.0) {
                            Text(quest.title)
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                            Text(quest.subtitle)
                                .foregroundColor(Color.white.opacity(0.9))
                        }
                        Spacer()
                        
                        ZStack {
                            VStack {
                                Image(systemName: "xmark")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.white)
                            }
                            .frame(width: 36, height: 36)
                            .background(Color.black)
                            .clipShape(Circle())
                            .onTapGesture {
                                self.show = false
                                self.active = false
                                self.activeIndex = -1
                            }
                        }
                    }
                    Spacer()
                    WebImage(url: quest.image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity)
                        .frame(height: 140, alignment: .top)
                }
                .padding(show ? 30 : 20)
                .padding(.top, show ? 30: 0)
                    //Laver en åben og luk animation
                    .frame(maxWidth: show ? .infinity : screen.width - 60, maxHeight: show ? 330 : 280)
                    .background(Color(quest.color))
                    .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                    .shadow(color: Color(quest.color).opacity(0.3), radius: 20, x: 0, y: 20)
                VStack(alignment: .leading, spacing: 30.0) {
                    
                    Text("Om denne quest")
                        .font(.title).bold()
                    Text("Lorem ipsum helt s34343434343434343434wewefwfwfwefwefwefwefwefwefwefwefwefikker jajajajjajajajajjajajaja.")
                    
                    Text("Lorem ipsum helt sikkewewewwweweweweweewewewewewewewewewewewewewwewewewdwdwdwdwdwdwdwdwdwdwdwdwwdqwqwdqwdqwdqdqwdqwdqwdqdqwdqwdqqwqwqqwdqdqwdqwdqwdqwdqwdqwdqwdwdwdwwqwdqwdwwdwdwqwdqwwwwwdqwdwdwdwdwdwdwderftggefdefefedfeedrdefrdeffdfredfefeeefefeferdfefefefdrdfefrdfefrdfefrderdfr jajajajjajasdsweobfweofwifnwefwewfjajajjajajasdsdsdssdssja.")
                }
                .padding(30.0)
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct QuestDetail_Previews: PreviewProvider {
    static var previews: some View {
        QuestDetail(quest: questData[0], show: .constant(true), active: .constant(true), activeIndex: .constant(-1))
    }
}
