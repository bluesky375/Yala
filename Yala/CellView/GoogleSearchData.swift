//
//  GoogleSearchData.swift
//  Yala
//
//  Created by Admin on 4/13/19.
//  Copyright © 2019 Yala. All rights reserved.
//

import Foundation
//
// MARK: - Section Data Structure
//
class GoogleSearchData{
    
    public struct Item {
        var name: String
        var detail: String
        var selected : Bool
        
        public init(name: String, detail: String, selected :Bool ) {
            self.name = name
            self.detail = detail
            self.selected = selected
        }
    }
    
    public struct Section {
        var name: String
        var items: [Item]
        var collapsed: Bool
        
        public init(name: String, items: [Item], collapsed: Bool = false) {
            self.name = name
            self.items = items
            self.collapsed = collapsed
        }
    }
    
    static var sectionsData: [Section] = [
        Section(name: "Price", items: [
            Item(name: "$", detail: "1", selected : false),
            Item(name: "$$", detail: "2", selected : false),
            Item(name: "$$$", detail: "3", selected : false),
            Item(name: "$$$$", detail: "4", selected : false)
            ]),
        Section(name: "Cuisines", items: [
            Item(name: "Bar/Lounge/Bottle Service", detail: "bar", selected : false),
            Item(name: "Barbecue", detail: "barbecue", selected : false),
            Item(name: "Basque", detail: "basque", selected : false),
            Item(name: "Beer Garden", detail: "beer", selected : false),
            Item(name: "Belgian", detail: "belgian", selected : false),
            Item(name: "Bistro", detail: "bistro", selected : false),
            Item(name: "Bottle Service", detail: "bottle", selected : false),
            Item(name: "Brazilian", detail: "Brazilian", selected : false),
            Item(name: "Breakfast", detail: "Breakfast", selected : false),
            Item(name: "British", detail: "British", selected : false),
            Item(name: "Cafe", detail: "cafe", selected : false),
            Item(name: "Chinese", detail: "chinese", selected : false),
            Item(name: "Comfort Food", detail: "food", selected : false),
            Item(name: "Stake", detail: "stake", selected : false),
            Item(name: "Bread", detail: "bread", selected : false),
            ])
    ]

    
}
