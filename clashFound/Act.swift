//
//  Act.swift
//  clashFound
//
//  Created by Mike Vinci on 9/4/22.
//

import Foundation

public class Act {
    var name: String
    var day: String
    var time: String
    var stage: String
    
    public init() {
        self.name = ""
        self.day = ""
        self.time = ""
        self.stage = ""
    }
    
    public init(name: String, day: String, time: String, stage: String){
        self.name = name
        self.day = day
        self.time = time
        self.stage = stage
    }
    
    func setName(name: String) {
        self.name = name
    }
    
    func setDay(day: String) {
        self.day = day
    }
    
    func setTime(time: String) {
        self.time = time
    }
    
    func setStage(stage: String) {
        self.stage = stage
    }
}
