//
//  Helper.swift
//  PrototypeApp
//
//  Created by Christian From Rasmussen on 04/05/2020.
//  Copyright © 2020 Christian From. All rights reserved.
//

import Foundation
import HealthKit


func start(healthStore: HKHealthStore, stepsRetrieved: Int){
    
    print("start runs")
    authorizeHealthKit(healthStore: healthStore)
    startStepCountQuery(healthStore: healthStore, stepsRetrieved: stepsRetrieved)
}

// Spørger om tilladelse
func authorizeHealthKit(healthStore: HKHealthStore) {
    let healthKitTypes: Set = [
        HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!]
    healthStore.requestAuthorization(toShare: healthKitTypes, read: healthKitTypes) {_, _ in}
    print("HealthKit authorized")
}
// Sender en query og får antal skridt tilbage for en hel dag.
func startStepCountQuery(healthStore: HKHealthStore, stepsRetrieved: Int){
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
            let stepsRetrieved = Int((result.sumQuantity()?.doubleValue(for: HKUnit.count()))!)
            print(stepsRetrieved)
            //checkDaily()
        })
    }
    healthStore.execute(query)
}
