//
//  RetouchingPhotoViewModel.swift
//  RetouchHome
//
//  Created by Vladyslav Panevnyk on 14.02.2021.
//

import Foundation
import RetouchDomain
import RetouchUtils
import RetouchDesignSystem

@MainActor
public protocol RetouchingPhotoViewModelDelegate: AnyObject {
    func didChangeTimer(_ leftTime: String)
    func didChangeToIndex(_ index: Int, animated: Bool)
}

@MainActor
public protocol RetouchingPhotoViewModelProtocol {
    var delegate: RetouchingPhotoViewModelDelegate? { get set }

    func startTimer()
    func invalidateTimer()
}

public final class RetouchingPhotoViewModel: RetouchingPhotoViewModelProtocol {
    // MARK: - Properties
    // Boundaries
    private let order: Order
    
    // Timer
    private let generalWaitingTime: Double // in milisec
    private let leftTimeStatusesChanging: [Double] // in milisec
    private var leftTime: Double = 0 // in milisec

    private var retouchingTimer: Timer?
    private let startOfToday = DateHelper.shared.utcCalendar.startOfDay(for: Date())
    private var currentStatus = 0

    // Formatters
    private let timerStyleFormatter = DateHelper.shared.timerStyleFormatter
    private let timeStyleFormatter = DateHelper.shared.timeStyleFormatter
    private let dateAndTimeStyleFormatter = DateHelper.shared.dateAndTimeStyleFormatter

    // Delegate
    public weak var delegate: RetouchingPhotoViewModelDelegate?

    // MARK: - Inits
    public init(order: Order) {
        self.order = order
        self.generalWaitingTime = order.calculatedWaitingTime
        self.leftTimeStatusesChanging = [order.calculatedWaitingTime]
    }

    // MARK: - Public methods
    public func startTimer() {
        self.leftTime = order.finishDate - Date().timeIntervalSince1970MiliSec
        setupCurrentStatus()
        runTimedCode()
        retouchingTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: true)
    }

    public func invalidateTimer() {
        retouchingTimer?.invalidate()
    }

    private func setupCurrentStatus() {
        for i in 0 ..< leftTimeStatusesChanging.count {
            if leftTimeStatusesChanging[i] < leftTime { break }
            else { currentStatus += 1 }
        }
        if currentStatus != 0 {
            delegate?.didChangeToIndex(currentStatus, animated: false)
        }
    }
}

// MARK: - Actions
extension RetouchingPhotoViewModel {
    @objc func runTimedCode() {
        guard leftTime > 0 else {
            invalidateTimer()
            delegate?.didChangeTimer("Waiting...")
            return
        }

        handleStatuses()
        delegate?.didChangeTimer(getFormattedLeftTime())
        leftTime -= 1000
    }
    
    private func getFormattedLeftTime() -> String {
        let leftTimeInSec = leftTime / 1000
        
        if leftTimeInSec < 60 * 60 {
            let leftTimeDate = startOfToday.addingTimeInterval(leftTimeInSec)
            return "Left around " + timerStyleFormatter.string(from: leftTimeDate)
        } else {
            let date = Date(timeIntervalSince1970MiliSec: order.creationDate)
            
            let preText = "You are in the waiting queue.\nRetouching will start"
            if DateHelper.shared.utcCalendar.isDateInToday(date) {
                let time = timeStyleFormatter.string(from: date)
                return "\(preText) today at \(time)"
            } else if DateHelper.shared.utcCalendar.isDateInTomorrow(date) {
                let time = timeStyleFormatter.string(from: date)
                return "\(preText) tomorrow at \(time)"
            } else {
                let time = dateAndTimeStyleFormatter.string(from: date)
                return "\(preText) at \(time)"
            }
        }
    }

    func handleStatuses() {
        guard currentStatus < leftTimeStatusesChanging.count else { return }

        if leftTimeStatusesChanging[currentStatus] >= leftTime {
            currentStatus += 1
            delegate?.didChangeToIndex(currentStatus, animated: true)
        }
    }
}
