//
//  CalendarController.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 28.06.2022.
//

import Foundation
import UIKit
import HorizonCalendar

typealias Day = DayComponents

class CalendarController: UIViewController {
    
    @IBOutlet var calendarContainer: UIView!
    @IBOutlet var topView: UIView!
    @IBOutlet var botView: UIView!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var searchButton: VmigButton!
    @IBOutlet var clearButton: UIButton!
    var calendarView: CalendarView!
    
    var action: ((Date?, Date?) -> ())?
    let calendar = Calendar.current
    
    var startDate: Date? {
        if let startDay = self.startDay {
            return calendar.date(from: DateComponents(year: startDay.month.year, month: startDay.month.month, day: startDay.day))!
        }
        return nil
    }
    var endDate: Date? {
        if let endDay = self.endDay {
            return calendar.date(from: DateComponents(year: endDay.month.year, month: endDay.month.month, day: endDay.day))!
        }
        return nil
    }
    
    var startDay: Day? {
        didSet {
            self.calendarView.setContent(self.makeContent())
        }
    }
    
    var endDay: Day? {
        didSet {
            self.calendarView.setContent(self.makeContent())
            self.searchButton.isEnabled = self.endDay != nil && self.endDay != self.startDay
            self.dateLabel.isHidden = self.endDay == nil || self.endDay == self.startDay
            if let endDate = endDate, let startDate = self.startDate {
                let datesString = "\(DateFormatter.ddMM.string(from: startDate))-\(DateFormatter.ddMM.string(from: endDate))"
                self.searchButton.dateLabel.text = datesString
                self.dateLabel.text = datesString + ", \(String.makeNights(self.calendar.numberOfDaysBetween(startDate, and: endDate)))"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    @IBAction func clearDatesPressed() {
        self.endDay = nil
        self.startDay = nil
        self.action?(nil, nil)
    }
    
    @IBAction func closePressed() {
        self.dismiss(animated: true)
    }
    
    func setupUI() {
        calendarView = CalendarView(initialContent: makeContent())
        self.calendarContainer.backgroundColor = Colors.f2f2f2
        self.topView.layer.cornerRadius = 20
//        self.botView.roundedCorners(top: true)
        self.botView.layer.cornerRadius = 20
        self.botView.makeCenterShadow()
        self.botView.backgroundColor = Colors.f2f2f2
        self.topView.backgroundColor = Colors.f2f2f2
        self.calendarView.backgroundColor = Colors.f2f2f2
        self.topView.makeCenterShadow()
        self.view.roundedCorners(top: true)
        self.commonSetup()
        
        self.searchButton.action = { [unowned self] in
            if let startDate = startDate, let endDate = self.endDate {
                self.action?(startDate, endDate)
                self.dismiss(animated: true)
            }
        }
        
        self.calendarContainer.addSubview(calendarView)
        
        calendarView.translatesAutoresizingMaskIntoConstraints = false

        calendarView.daySelectionHandler = { [weak self] day in
            guard let self = self else {return}
            if let startDay = self.startDay, day < startDay {
                self.startDay = day
            } else if let endDay = self.endDay, day > endDay {
                self.endDay = day
            } else {
                self.startDay == nil ? (self.startDay = day) : (self.endDay = day)
            }
        }
        
        NSLayoutConstraint.activate([
          calendarView.leadingAnchor.constraint(equalTo: calendarContainer.layoutMarginsGuide.leadingAnchor),
          calendarView.trailingAnchor.constraint(equalTo: calendarContainer.layoutMarginsGuide.trailingAnchor),
          calendarView.topAnchor.constraint(equalTo: calendarContainer.layoutMarginsGuide.topAnchor),
          calendarView.bottomAnchor.constraint(equalTo: calendarContainer.layoutMarginsGuide.bottomAnchor),
        ])
    }
    
    private func makeContent() -> CalendarViewContent {
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: "ru_RU")
        
        let startDate = Date()//.startOfMonth()
        var dateComponent = DateComponents()
        dateComponent.year = 1
        let endDate = Calendar.current.date(byAdding: dateComponent, to: startDate)!.endOfMonth()


        return CalendarViewContent(calendar: calendar,
                                   visibleDateRange: startDate...endDate,
                                   monthsLayout: .vertical(options: VerticalMonthsLayoutOptions(pinDaysOfWeekToTop: true, alwaysShowCompleteBoundaryMonths: false)))
        .dayItemProvider { day in
            var invariantViewProperties = DayLabel.InvariantViewProperties(
                font: Fonts.regular(size: 16),
                textColor: Colors.mainBlack,
                backgroundColor: .clear)

            if day == self.startDay || day == self.endDay {
                invariantViewProperties.textColor = .white
                invariantViewProperties.backgroundColor = Colors.main
            }
            
            if let startDay = self.startDay, let endDay = self.endDay, day > startDay && day < endDay {
                invariantViewProperties.backgroundColor = Colors.DDDDDD
            }
            
            //            return CalendarItemModel<DayLabel>(invariantViewProperties: invariantViewProperties,
            return CalendarItemModel<DayLabel>(invariantViewProperties: invariantViewProperties)
        }
        .interMonthSpacing(24)
        .verticalDayMargin(5)
        .horizontalDayMargin(5)
    }
    
}
