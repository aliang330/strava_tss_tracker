//
//  Analyze.swift
//  StravaActivityGetter
//
//  Created by Allen on 6/4/20.
//  Copyright © 2020 Allen. All rights reserved.
//

import Foundation

class Analyze {
    
    static let shared = Analyze()
    
    func calculateBestPowers(data: [Int?]) -> [Double] {
        var allOneMinutePowers = [Double]()
        for i in 0..<data.count {
            var sum = 0.0
            if i <= data.count - 60 {
                if data[i] != nil {
                    for j in i..<i + 60 {
                        if data[j] != nil {
                            sum += Double(data[j]!)
                        }
                    }
                }
                allOneMinutePowers.append(sum/60)
            }
        }
        
        var allFiveMinutePowers = [Double]()
        for i in 0..<data.count {
            var sum = 0.0
            if i <= data.count - 300 {
                if data[i] != nil {
                    for j in i..<i + 300 {
                        if data[j] != nil {
                            sum += Double(data[j]!)
                        }
                    }
                }
                allFiveMinutePowers.append(sum/300)
            }
        }

        var allTenMinutePowers = [Double]()
        for i in 0..<data.count {
            var sum = 0.0
            if i <= data.count - 600 {
                if data[i] != nil {
                    for j in i..<i + 600 {
                        if data[j] != nil {
                            sum += Double(data[j]!)
                        }
                    }
                }
                allTenMinutePowers.append(sum/600)
            }
        }
        
        var allFifteenMinutePowers = [Double]()
        for i in 0..<data.count {
            var sum = 0.0
            if i <= data.count - 900 {
                if data[i] != nil {
                    for j in i..<i + 900 {
                        if data[j] != nil {
                            sum += Double(data[j]!)
                        }
                    }
                }
                allFifteenMinutePowers.append(sum/900)
            }
        }
        
//        var allTwentyMinutePowers = [Double]()
//        for i in 0..<data.count {
//            var sum = 0.0
//            if i <= data.count - 1200 {
//                if data[i] != nil {
//                    for j in i..<i + 1200 {
//                        if data[j] != nil {
//                            sum += Double(data[j]!)
//                        }
//                    }
//                }
//                allTwentyMinutePowers.append(sum/1200)
//            }
//        }
//        print("\nBest one minute power \(allOneMinutePowers.max() ?? -1.0)")
//        print("\nBest five minute power \(allFiveMinutePowers.max() ?? -1.0)")
//        print("\nBest ten minute power \(allTenMinutePowers.max() ?? -1.0)")
//        print("\nBest fifteen minute power \(allFifteenMinutePowers.max() ?? -1.0)")
//        print("\nBest twenty minute power \(allTwentyMinutePowers.max() ?? -1.0)")
        
        let powers = [allOneMinutePowers.max() ?? 0, allFiveMinutePowers.max() ?? 0, allTenMinutePowers.max() ?? 0, allFifteenMinutePowers.max() ?? 0, 0.0]//allTwentyMinutePowers.max() ?? 0]
        
        return powers
        
    }
    //takes dataStream of Power in watts as array of ints and returns TSS
    func calculateTSS(data: [Int], movingTime: Int) -> Double {
        if data.count < 30 {
            return 0.0
        }
        var rollingAvg = 0
        var rollingAvgs = [Int]()
        for i in 0..<data.count {
            if i < data.count - 30 {
                for j in i..<i+30 {
                    rollingAvg += data[j]
                }
                rollingAvgs.append(rollingAvg/30)
                rollingAvg = 0
            }
        }
        var rollingAvgPowered = [Double]()
        for i in 0..<rollingAvgs.count {
            rollingAvgPowered.append(pow(Double(rollingAvgs[i]), 4.0))
        }
        let sum = Double(rollingAvgPowered.reduce(0, +))
        let avgPoweredValues = sum/Double(rollingAvgPowered.count)
        let NP = pow(avgPoweredValues, 0.25)
        let t = Double(movingTime)  //need to grab moving_time as t
        let IF = NP/FTP
        let TSS = (t * NP * IF) / (FTP * 36.0)
        
        return TSS
    }
}
