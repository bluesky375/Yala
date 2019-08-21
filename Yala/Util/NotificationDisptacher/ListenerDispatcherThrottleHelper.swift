//
//  ListenerDispatcher.swift
//  Yala
//
//  Created by Ankita on 07/08/18.
//  Copyright © 2018 Yala. All rights reserved.
//

import Foundation

/**
    This protocol contains delegate method to ensure if event needs to be delivered or not
 */

protocol ListenersDispatcherThrottleHelperDelegate: class {
    /**
     *  Called when event should be delivered by a delegate.
     */
    func listenersDispatcherThrottleHelper(_ helper: ListenerDispatcherThrottleHelper, shouldDeliverEvent event: AnyObject)
}

/**
    This class is responsible for event throttling based on timer interval and works in conjuction with ListenerDispatcher for event dispatch. 
 */

class ListenerDispatcherThrottleHelper {
    
    weak var delegate: ListenersDispatcherThrottleHelperDelegate?
    
    // event type (as String) -> throttle value for this type
    var throttleValues = [String: Double]()
    
    // event type (as String) -> last received event of this type
    var lastEvents = [String: AnyObject]()
    
    // event type (as String) -> timer for this type
    var timers = [String: Timer]()
    
    init(delegate: ListenersDispatcherThrottleHelperDelegate?) {
        self.delegate = delegate
    }
    
    func setThrottle(_ throttleValue: TimeInterval, forEventType eventType: AnyClass) {
        throttleValues[dictKeyForEventType(eventType)] = throttleValue
    }
    
    func throttle(forEventType eventType: AnyClass) -> Double {
        return throttleValues[dictKeyForEventType(eventType)]!
    }
    
    func removeThrottle(forEventType eventType: AnyClass) {
        throttleValues.removeValue(forKey: dictKeyForEventType(eventType))
    }
    
    func isThrottleEnabled(forEventType eventType: AnyClass) -> Bool {
        return throttle(forEventType: eventType) > 0.0
    }
    
    func isTimerStarted(forEventType eventType: AnyClass) -> Bool {
        return timers[dictKeyForEventType(eventType)] != nil
    }
    
    func scheduleEvent(_ event: AnyObject) {
        assert(isThrottleEnabled(forEventType: type(of: event)), "Throttling must be enabled to schedule event")
        
        if !isThrottleEnabled(forEventType: type(of: event)) {
            return
        }
        
        let eventTypeString: String = dictKeyForEventType(type(of: event))
        lastEvents[eventTypeString] = event
        if !isTimerStarted(forEventType: type(of: event)) {
            startTimer(forEventType: type(of: event))
        }
    }
    
    func stopTimers() {
        for (_, timer) in timers {
            timer.invalidate()
        }
        timers.removeAll()
    }
    
    // MARK: Private
    
    func startTimer(forEventType eventType: AnyClass) {
        let throttleValue = throttleValues[dictKeyForEventType(eventType)]
        assert(throttleValue != nil, "Throttle value must be set")
        
        let timer = Timer(timeInterval: throttleValue!,
                          target: self,
                          selector: #selector(timerFired(_:)),
                          userInfo: eventType,
                          repeats: false)
        RunLoop.main.add(timer, forMode: .commonModes)
        timers[dictKeyForEventType(eventType)] = timer
    }

    @objc func timerFired(_ timer: Timer) {
        assert(Thread.isMainThread, "Timer must fire in main thread")
        
        let eventType = timer.userInfo
        
        guard let eventType1 = eventType as? AnyClass else {
            return
        }
        
        let eventTypeString: String = dictKeyForEventType(eventType1)
        
        timers.removeValue(forKey: eventTypeString)
        
        let lastEvent = lastEvents[eventTypeString]
        
        if lastEvent != nil {
            lastEvents.removeValue(forKey: eventTypeString)
            self.delegate?.listenersDispatcherThrottleHelper(self, shouldDeliverEvent: lastEvent!)
        }
    }
    
    private func dictKeyForEventType(_ eventType: AnyClass) -> String {
        return String(describing: eventType.self)
    }
    
    deinit {
        stopTimers()
    }
}
