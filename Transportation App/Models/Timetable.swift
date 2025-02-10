//
//  Timetable.swift
//  Transportation App
//
//  Created by Cüneyt Elbastı on 07.02.2025.
//

struct TimetableResponse: Codable {
    let departures: [TimetableData]
    
    enum CodingKeys: String, CodingKey {
        case departures
    }
}

struct TimetableData: Codable {
    let serviceName: String
    let destination: String
    let noteId: String?
    let validFrom: Int
    let day: Int
    let time: String
    let stopId: String?
    
    enum CodingKeys: String, CodingKey {
        case serviceName = "service_name"
        case destination
        case noteId = "note_id"
        case validFrom = "valid_from"
        case day
        case time
        case stopId = "stop_id"
    }
}

extension TimetableData {
    var formattedDayText: String {
        switch day {
        case 1:
            return "Weekday"
        case 5:
            return "Saturday"
        case 6:
            return "Sunday"
        default:
           return "Weekday"
        }
    }
} 
