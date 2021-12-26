//
//  LocalState.swift
//  Bankey
//
//  Created by praveen mack on 27/12/21.
//

import Foundation

public class LocalState {
    
    private enum Keys: String {
        case hasOnboard
    }
    
    public static var hasOnboarded: Bool {
        get {
            return UserDefaults.standard.bool(forKey: Keys.hasOnboard.rawValue)
        }
        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: Keys.hasOnboard.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
    
}
