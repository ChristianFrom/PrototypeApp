//
//  QuestList.swift
//  PrototypeApp
//
//  Created by Christian From Rasmussen on 02/05/2020.
//  Copyright © 2020 Christian From. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct QuestList: View {
    @ObservedObject var store = QuestStore()
    @State var active = false
    @State var activeIndex = -1
    @State var activeView = CGSize.zero
    
    var body: some View {
        ZStack {
            //Ændrer baggrundens opacity når man trækker i kortet
            Color.black.opacity(Double(self.activeView.height / 500))
                .animation(.linear)
                .edgesIgnoringSafeArea(.all)
        
            ScrollView {
                VStack(spacing: 30) {
                    Text("Quests")
                        .font(.largeTitle).bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 30)
                        .padding(.top, 30)
                        .blur(radius: active ? 20 : 0)
                    ForEach(store.quests.indices, id: \.self) { index in
                        GeometryReader { geometry in
                            QuestView(
                                show: self.$store.quests[index].show,
                                quest: self.store.quests[index],
                                active: self.$active,
                                index: index,
                                activeIndex: self.$activeIndex,
                                activeView: self.$activeView
                            )
                                .offset(y: self.store.quests[index].show ? -geometry.frame(in: .global).minY : 0)
                                .opacity(self.activeIndex != index && self.active ? 0 : 1)
                                //Ændrer størrelsen på de kort, som man ikke har valgt
                                .scaleEffect(self.activeIndex != index && self.active ? 0.5 : 1)
                                //Rykker de kort, som man ikke har valgt til højre
                                .offset(x: self.activeIndex != index && self.active ? screen.width : 0)
                        }
                        .frame(height: 280)
                        .frame(maxWidth: self.store.quests[index].show  ? .infinity : screen.width - 60)
                            //Hvis man trykker på en kort, så bliver zIndexet ændret, så kortet ligger ovenpå de andre.
                            .zIndex(self.store.quests[index].show ? 1 : 0)
                    }
                }
                .frame(width: screen.width)
                .animation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0))
            }
                //Gemmer status bar når man trykker på et kort
                .statusBar(hidden: active ? true : false)
                .animation(.linear)
        }
    }
}

struct QuestList_Previews: PreviewProvider {
    static var previews: some View {
        QuestList()
    }
}

struct QuestView: View {
    @Binding var show: Bool
    var quest: Quest
    @Binding var active: Bool
    var index: Int
    @Binding var activeIndex: Int
    @Binding var activeView: CGSize
    
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 30.0) {
                
                Text("Om denne quest")
                    .font(.title).bold()
                Text("Lorem ipsum helt s34343434343434343434wewefwfwfwefwefwefwefwefwefwefwefwefikker jajajajjajajajajjajajaja.")
                
                Text("Lorem ipsum helt sikkewewewwweweweweweewewewewewewewewewewewewewwewewewdwdwdwdwdwdwdwdwdwdwdwdwwdqwqwdqwdqwdqdqwdqwdqwdqdqwdqwdqqwqwqqwdqdqwdqwdqwdqwdqwdqwdqwdwdwdwwqwdqwdwwdwdwqwdqwwwwwdqwdwdwdwdwdwdwderftggefdefefedfeedrdefrdeffdfredfefeeefefeferdfefefefdrdfefrdfefrdfefrderdfr jajajajjajasdsweobfweofwifnwefwewfjajajjajajasdsdsdssdssja.")
            }
            .padding(30.0)
            .frame(maxWidth: show ? .infinity : screen.width - 60, maxHeight: show ? .infinity : 280, alignment: .top)
            .offset(y: show ? 460 : 0)
            .background(Color("background2"))
            .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
            .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 20)
            .opacity(show ? 1 : 0)
            
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
                    
                    //Logo som skifter til en lukke knap, når show er true.
                    ZStack {
                        Image(uiImage: quest.logo)
                            .opacity(show ? 0 : 1)
                        
                        VStack {
                            Image(systemName: "xmark")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.white)
                        }
                        .frame(width: 36, height: 36)
                        .background(Color.black)
                        .clipShape(Circle())
                        .opacity(show ? 1 : 0)
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
                .frame(maxWidth: show ? .infinity : screen.width - 60, maxHeight: show ? 460 : 280)
                .background(Color(quest.color))
                .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                .shadow(color: Color(quest.color).opacity(0.3), radius: 20, x: 0, y: 20)
                .gesture(
                    show ?
                        DragGesture().onChanged { value in
                            guard value.translation.height < 300  else { return }
                            guard value.translation.height > 0 else { return }
                            self.activeView = value.translation
                            
                        }
                        .onEnded { value in
                            if self.activeView.height > 50 {
                                self.show = false
                                self.active = false
                                self.activeIndex = -1
                            }
                            self.activeView = .zero
                        }
                        : nil
            )
                .onTapGesture {
                    self.show.toggle()
                    self.active.toggle()
                    if self.show {
                        self.activeIndex = self.index
                    } else {
                        self.activeIndex = -1
                    }
            }
        }
        .frame(height: show ? screen.height : 280)
            //Ændrer kortets størrelse når man rykker den
            .scaleEffect(1 - self.activeView.height / 1000)
            .rotation3DEffect(Angle(degrees: Double(self.activeView.height / 10)), axis: (x: 0, y: 10.0, z: 0))
            .hueRotation(Angle(degrees: Double(self.activeView.height)))
            .animation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0))
            .gesture(
                    show ?
                        DragGesture().onChanged { value in
                            guard value.translation.height < 300  else { return }
                            guard value.translation.height > 0 else { return }
                            
                            self.activeView = value.translation
                            
                        }
                        .onEnded { value in
                            if self.activeView.height > 50 {
                                self.show = false
                                self.active = false
                                self.activeIndex = -1
                            }
                            self.activeView = .zero
                        }
                        : nil
        )
            .edgesIgnoringSafeArea(.all)
        
    }
}

struct Quest: Identifiable {
    var id = UUID()
    var title: String
    var subtitle: String
    var image: URL
    var logo: UIImage
    var color: UIColor
    var show: Bool
}

var questData = [
    
    Quest(title: "Hello World", subtitle: "Walk 2500 steps in a day", image: URL(string: "https://dl.dropbox.com/s/e9m8qxh51vmxa4t/Card4%402x.png?dl=0")!, logo: #imageLiteral(resourceName: "Logo1"), color: #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1), show: false),
    Quest(title: "Hello World 2", subtitle: "Walk 5000 steps in a day", image: URL(string: "https://dl.dropbox.com/s/e9m8qxh51vmxa4t/Card4%402x.png?dl=0")!, logo: #imageLiteral(resourceName: "Logo1"), color: #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1), show: false ),
    Quest(title: "Hello World 3", subtitle: "Walk 10000 steps in a day", image: URL(string: "https://dl.dropbox.com/s/e9m8qxh51vmxa4t/Card4%402x.png?dl=0")!, logo: #imageLiteral(resourceName: "Logo1"), color: #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1), show: false)
]
