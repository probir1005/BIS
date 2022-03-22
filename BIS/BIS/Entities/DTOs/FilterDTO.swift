//
//  FilterDTO.swift
//  BIS
//
//  Created by TSSIOS on 06/07/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

struct FilterDTO {
    var category: String?
    var calendarFilters: CalendarFilterDTO?
    var clientFilters: [ItemFilterDTO]? = []
    var regionFilters: [ItemFilterDTO]? = []
    var marketFilters: [ItemFilterDTO]? = []
    var salesPICFilters: [ItemFilterDTO]? = []
}

extension FilterDTO {
    init(json: [String: Any]) {
        self.category = json["category"] as? String
        self.calendarFilters = CalendarFilterDTO.init(json: (json["calendarData"] as? [String: Any] ?? [:])) 
        self.clientFilters = (json["clientData"] as? [[String: Any]])?.enumerated().map { (_, obj) in ItemFilterDTO.init(json: obj) }.sorted { $0.title! < $1.title! }
        self.regionFilters = (json["regionData"] as? [[String: Any]])?.enumerated().map { (_, obj) in ItemFilterDTO.init(json: obj) }.sorted { $0.title! < $1.title! }
        self.marketFilters = (json["marketData"] as? [[String: Any]])?.enumerated().map { (_, obj) in ItemFilterDTO.init(json: obj) }.sorted { $0.title! < $1.title! }
        self.salesPICFilters = (json["salesPICData"] as? [[String: Any]])?.enumerated().map { (_, obj) in ItemFilterDTO.init(json: obj) }.sorted { $0.title! < $1.title! }
    }
}

struct CalendarFilterDTO {
    var title: String?
    var calendarYearFilter: [ItemFilterDTO]? = []
    var calendarMonthFilter: [ItemFilterDTO]? = []
    var calendarWeekFilter: [ItemFilterDTO]? = []
    var calendarDateFilter: [ItemFilterDTO]? = []
}

extension CalendarFilterDTO {
    init(json: [String: Any]) {
        self.title = json["name"] as? String
        self.calendarYearFilter = (json["year"] as? [[String: Any]])?.enumerated().map { (_, obj) in ItemFilterDTO.init(json: obj) }
        self.calendarMonthFilter = (json["month"] as? [[String: Any]])?.enumerated().map { (_, obj) in ItemFilterDTO.init(json: obj) }
        self.calendarWeekFilter = (json["week"] as? [[String: Any]])?.enumerated().map { (_, obj) in ItemFilterDTO.init(json: obj) }
        self.calendarDateFilter = (json["days"] as? [[String: Any]])?.enumerated().map { (_, obj) in ItemFilterDTO.init(json: obj) }
    }
}

struct ItemFilterDTO {
    var title: String?
    var isSelected: Bool = false
}

extension ItemFilterDTO {
    init(json: [String: Any]) {
        self.title = json["name"] as? String
        self.isSelected = json["isSelected"] as? Bool ?? false
    }
}
