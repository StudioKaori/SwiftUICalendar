//
//  CalendarView.swift
//  SwiftUICalendar
//
//  Created by Kaori Persson on 2023-03-21.
//

import SwiftUI

struct CalendarDates: Identifiable {
  var id = UUID()
  var date: Date?
}

struct CalendarView: View {
  
  let calendarDate: Date?
  let year: Int
  let month: Int
  let calendarDates: [CalendarDates]
  let weekdays = Calendar.current.shortWeekdaySymbols
  
//  let year = Calendar.current.year(for: calendarDate) ?? 0
//  let month = Calendar.current.month(for: Date()) ?? 0
//  let calendarDates = createCalendarDates(Date())
//  let weekdays = Calendar.current.shortWeekdaySymbols
  
  init() {
    self.calendarDate = Date()
    self.year = Calendar.current.year(for: self.calendarDate!) ?? 0
    self.month = Calendar.current.month(for: self.calendarDate!) ?? 0
    self.calendarDates = createCalendarDates(self.calendarDate!)
  }
  
  init(year: Int, month: Int) {
    let dateString = "\(year)-\(month)"
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM"
    self.calendarDate = dateFormatter.date(from: dateString)
    self.year = Calendar.current.year(for: self.calendarDate!) ?? 0
    self.month = Calendar.current.month(for: self.calendarDate!) ?? 0
    self.calendarDates = createCalendarDates(self.calendarDate!)
  }
  
  let columns: [GridItem] = Array(repeating: .init(.fixed(40)), count: 7)
  
  var body: some View {
    VStack {
      Text(String(format: "%04d/%02d", year, month))
        .font(.system(size: 24))
      
      HStack {
        ForEach(weekdays, id: \.self) { weekday in
          Text(weekday).frame(width: 40, height: 40, alignment: .center)
        }
      }
      
      LazyVGrid(columns: columns, spacing: 20) {
        ForEach(calendarDates) { calendarDates in
          if let date = calendarDates.date, let day = Calendar.current.day(for: date) {
            Text("\(day)")
          } else {
            Text("")
          }
        }
      }
    }
    .frame(width: 400, height: 400, alignment: .center)
  }
}

struct CalendarView_Previews: PreviewProvider {
  static var previews: some View {
    CalendarView()
  }
}

extension Calendar {
  /// Get the start day of the month
  /// - Parameter date: target date
  /// - Returns: start day
  func startOfMonth(for date:Date) -> Date? {
    let comps = dateComponents([.month, .year], from: date)
    return self.date(from: comps)
  }
  
  /// Get the number of the month
  /// - Parameter date: target month
  /// - Returns: days
  func daysInMonth(for date:Date) -> Int? {
    return range(of: .day, in: .month, for: date)?.count
  }
  
  /// Get the number of week in the month
  /// - Parameter date: target month
  /// - Returns: number of week
  func weeksInMonth(for date:Date) -> Int? {
    return range(of: .weekOfMonth, in: .month, for: date)?.count
  }
  
  func year(for date: Date) -> Int? {
    let comps = dateComponents([.year], from: date)
    return comps.year
  }
  
  func month(for date: Date) -> Int? {
    let comps = dateComponents([.month], from: date)
    return comps.month
  }
  
  func day(for date: Date) -> Int? {
    let comps = dateComponents([.day], from: date)
    return comps.day
  }
  
  func weekday(for date: Date) -> Int? {
    let comps = dateComponents([.weekday], from: date)
    return comps.weekday
  }
}

/// Generate calendar dates
/// - Parameter date: target month
/// - Returns: Calendar dates
func createCalendarDates(_ date: Date) -> [CalendarDates] {
  var days = [CalendarDates]()
  
  let startOfMonth = Calendar.current.startOfMonth(for: date)
  let daysInMonth = Calendar.current.daysInMonth(for: date)
  
  guard let daysInMonth = daysInMonth, let startOfMonth = startOfMonth else { return [] }
  
  // All days in the month
  for day in 0..<daysInMonth {
    days.append(CalendarDates(date: Calendar.current.date(byAdding: .day, value: day, to: startOfMonth)))
  }
  
  guard let firstDay = days.first, let lastDay = days.last,
        let firstDate = firstDay.date, let lastDate = lastDay.date,
        let firstDateWeekday = Calendar.current.weekday(for: firstDate),
        let lastDateWeekday = Calendar.current.weekday(for: lastDate) else { return [] }
  
  // a number of offset days of the first week
  let firstWeekEmptyDays = firstDateWeekday - 1
  // a number of offset days of the final week
  let lastWeekEmptyDays = 7 - lastDateWeekday
  
  // Add first week offset
  for _ in 0..<firstWeekEmptyDays {
    days.insert(CalendarDates(date: nil), at: 0)
  }
  
  // Add last week offset
  for _ in 0..<lastWeekEmptyDays {
    days.append(CalendarDates(date: nil))
  }
  
  return days
}
