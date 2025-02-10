//
//  TimetableViewModel.swift
//  Transportation App
//
//  Created by Cüneyt Elbastı on 07.02.2025.
//



import UIKit

final class TimetableViewModel {
    private let service: TransportService
    private let serviceNumber: String
    private let stopId: Int
    
    @Published private(set) var departures: [TimetableData] = []
    @Published private(set) var filteredDepartures: [TimetableData] = []
    @Published private(set) var isLoading = false
    @Published private(set) var error: String?
    @Published private(set) var selectedDayType: DayType = .weekday
    
    enum DayType: Int {
        case weekday = 0
        case saturday = 1
        case sunday = 2
        
        var dayValue: Int {
            switch self {
            case .weekday, .saturday:
                return 1
            case .sunday:
                return 6
            }
        }
    }
    
    init(service: TransportService = TransportService(), serviceNumber: String, stopId: Int) {
        self.service = service
        self.serviceNumber = serviceNumber
        self.stopId = stopId
    }
    
    func fetchTimetables() async {
        await MainActor.run { self.isLoading = true }
        
        do {
            let timetables = try await service.fetchTimetable(for: stopId)
            await MainActor.run {
                self.departures = timetables
                    .filter { $0.serviceName == self.serviceNumber }
                    .sorted { $0.time < $1.time }
                self.filterDeparturesForSelectedDay()
                self.isLoading = false
            }
        } catch {
            await MainActor.run {
                self.error = error.localizedDescription
                self.isLoading = false
            }
        }
    }
    
    func updateSelectedDayType(_ index: Int) {
        selectedDayType = DayType(rawValue: index) ?? .weekday
        filterDeparturesForSelectedDay()
    }
    
    private func filterDeparturesForSelectedDay() {
        filteredDepartures = departures.filter { departure in
            switch selectedDayType {
            case .weekday, .saturday:
               
                return departure.day == 1 || departure.day == 0
            case .sunday:
                return departure.day == 6
            }
        }.sorted { $0.time < $1.time } 
    }
} 
