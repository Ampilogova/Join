//
//  ThemeService.swift
//  Join
//
//  Created by Tatiana Ampilogova on 10/8/20.
//

import Foundation

class ThemeService {
    
    let userDefaults = UserDefaults.standard
    
    func allThemes() -> [ThemeModel] {
        let classicTheme = ThemeModel(name: "Classic", backgroundColor: .white, textColor: .black, incoming: .customGray, outgoing: .customGreen)
        let dayTheme = ThemeModel(name: "Day", backgroundColor: .customWhite, textColor: .black, incoming: .silver, outgoing: .customBlue)
        let nightTheme = ThemeModel(name: "Night", backgroundColor: .black, textColor: .white, incoming: .customDarkestGray, outgoing: .customDarkGray)
        return [classicTheme, dayTheme, nightTheme]
    }
    
    func saveTheme(theme: ThemeModel) {
        userDefaults.setColor(color: theme.backgroundColor, forKey: "backgroundColor")
        userDefaults.setColor(color: theme.incoming, forKey: "incoming")
        userDefaults.setColor(color: theme.outgoing, forKey: "outgoing")
        userDefaults.setColor(color: theme.textColor, forKey: "textColor")
        userDefaults.set(theme.name, forKey: "name")
    }
    
    func currentTheme() -> ThemeModel {
        guard let name = userDefaults.string(forKey: "name"),
              let backgroundColor = userDefaults.colorForKey(key: "backgroundColor"),
              let textColor = userDefaults.colorForKey(key: "textColor"),
              let incoming = userDefaults.colorForKey(key: "incoming"),
              let outgoing = userDefaults.colorForKey(key: "outgoing") else { return allThemes()[0] }
         return ThemeModel(name: name, backgroundColor: backgroundColor, textColor: textColor, incoming: incoming, outgoing: outgoing)
    }
}
