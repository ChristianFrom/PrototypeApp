//
//  HomeView.swift
//  PrototypeApp
//
//  Created by Christian From Rasmussen on 01/05/2020.
//  Copyright © 2020 Christian From. All rights reserved.
//

import SwiftUI
import HealthKit


//Til healthkit og skridttæller
private var healthStore = HKHealthStore()


struct HomeView: View {
    @Binding var showProfile: Bool
    @Binding var showContent: Bool
    @State var showUpdate = false
    @State var stepsRetrieved = 0
    @State var dailySteps = 2000
    @State var stepsTextNumber: Int
    
    
    var body: some View {
        GeometryReader { bounds in
            VStack {
                HStack {
                    Text("Welcome!")
                        .font(.system(size: 28, weight: .bold))
                    
                    Spacer()
                    
                    // Profil knap og updates knap
                    AvatarView(showProfile: self.$showProfile)
                    
                    //Knap ved siden af avatar
                    //Modal presentation
                    Button(action: { self.showUpdate.toggle() }) {
                        Image(systemName: "bell")
                            .foregroundColor(.primary)
                            .font(.system(size: 16, weight: .medium))
                            .frame(width: 36, height: 36)
                            .background(Color("background3"))
                            .clipShape(Circle())
                            .shadow(color: Color.black.opacity(0.1), radius: 1, x: 0, y: 1)
                            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 10)
                        
                    }
                    .sheet(isPresented: self.$showUpdate) {
                        UpdateList()
                    }
                }
                .padding(.horizontal)
                .padding(.leading, 14)
                .padding(.top, 30)
                
                // Progressions Ring med "Daily Steps"
                HStack {
                    HStack(spacing: 12.0) {
                        // Lav percentage til at være dynamisk
                        RingView(color1: #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1), color2: #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1), width: 44, height: 44, percentage: 69, show: .constant(true))
                        VStack(alignment: .leading, spacing: 4.0) {
                            Text("Daily Steps").bold().modifier(FontModifier(style: .subheadline))
                            Text("\(self.stepsTextNumber)/\(self.dailySteps) steps today").modifier(FontModifier(style: .caption))
                            
                        }
                        .modifier(FontModifier())
                    }
                    .padding(8)
                    .background(Color("background3"))
                    .cornerRadius(20)
                    .modifier(ShadowModifier())
                }
                
                Spacer()
                
                //Scrollview med Quests, Inventory og Stats
                VStack {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20) {
                            ForEach(sectionData) { item in
                                GeometryReader { geometry in
                                    SectionView(section: item)
                                        .rotation3DEffect(Angle(degrees:
                                            Double(geometry.frame(in: .global).minX - 30) / -35
                                        ), axis: (x: 0, y: 10, z: 0))
                                }
                                .frame(width: 275, height: 275)
                                .onTapGesture {
                                    self.showContent = true
                                }
                            }
                        }
                        //.frame(width: 375, height: 300)
                        .padding(.bottom, 10)
                        .onAppear(perform: self.start)
                    }
                }
            }
        }
    }
    
    
    func checkDaily(){
        if stepsRetrieved > dailySteps {
            stepsTextNumber = dailySteps
        }
        else {
            stepsTextNumber = stepsRetrieved
        }
    }
    
    
    func start(){
        print("start runs")
        authorizeHealthKit()
        startStepCountQuery()
    }
    
    // Spørger om tilladelse
    func authorizeHealthKit() {
        let healthKitTypes: Set = [
            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!]
        healthStore.requestAuthorization(toShare: healthKitTypes, read: healthKitTypes) {_, _ in}
        print("HealthKit authorized")
    }
    
    // Sender en query og får antal skridt tilbage for en hel dag.
    func startStepCountQuery(){
        guard let stepCountType = HKObjectType.quantityType(forIdentifier: .stepCount) else {
            fatalError("could not set object type")
        }
        
        var interval = DateComponents()
        interval.hour = 24
        
        let cal = Calendar.current
        let anchorDate = cal.date(bySettingHour: 0, minute: 0, second: 0, of: Date())
        
        let query = HKStatisticsCollectionQuery.init(quantityType: stepCountType, quantitySamplePredicate: nil, options: .cumulativeSum, anchorDate: anchorDate!, intervalComponents: interval)
        
        query.initialResultsHandler = {
            query, results, error in
            let startDate = cal.startOfDay(for: Date())
            results?.enumerateStatistics(from: startDate, to: Date(), with: { (result, stop) in
                self.stepsRetrieved = Int((result.sumQuantity()?.doubleValue(for: HKUnit.count())) ?? 0)
                print(self.stepsRetrieved)
                self.checkDaily()
            })
        }
        healthStore.execute(query)
    }
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(showProfile: .constant(false), showContent: .constant(false), stepsTextNumber: 0).environmentObject(UserStore())
    }
}

struct SectionView: View {
    var section: Section
    var width: CGFloat = 275
    var height: CGFloat = 275
    
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                Text(section.title)
                    .font(.system(size: 24, weight: .bold))
                    .frame(width: 170, alignment: .leading)
                    .foregroundColor(.white)
                Spacer()
                Image(section.logo)
            }
            
            Text(section.text.uppercased())
                .frame(maxWidth: .infinity, alignment: .leading)
            
            section.image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 210)
            Spacer()
        }
        .padding(.top, 20)
        .padding(.horizontal, 20)
        .frame(width: width, height: height)
        .background(section.color)
        .cornerRadius(30)
        //Reflektere farven som en skygge
        .shadow(color: section.color.opacity(0.3), radius: 20, x: 0, y: 20)
    }
}

//Data Model
struct Section: Identifiable {
    // Giver en unik ID
    var id = UUID()
    var title: String
    var text: String
    var logo: String
    var image: Image
    var color: Color
}

let sectionData = [
    
    Section(title: "Quests", text: "Complete quests and earn fame!", logo: "Logo1",
            image: Image(uiImage: #imageLiteral(resourceName: "Card4") ), color: Color(#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1))),
    Section(title: "Inventory", text: "Your earned items", logo: "Logo1",
            image: Image(uiImage: #imageLiteral(resourceName: "Card3") ), color: Color(#colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1))),
    Section(title: "Stats", text: "Your total stats", logo: "Logo1",
            image: Image(uiImage: #imageLiteral(resourceName: "Card5") ), color: Color(#colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)))
    
]
