//
//  ListenerDispatcher.swift
//  Yala
//
//  Created by Ankita on 07/08/18.
//  Copyright © 2018 Yala. All rights reserved.
//

import Foundation

/**
    This protocol provides delegate called on event fire
 */
protocol ListenerDispatcherProtocol: class {
    func didFireEventWithDispatcher(_ dispatcher: ListenerDispatcher, withEvent event: AnyObject)
}

/**
    This class provides dispatcher options like event throttling
 */
class ListenersDispatcherOptions {
    var isIgnoreThrottling = true
}

/**
    This class is listener dispatcher helper class which contains eventType, listenerProtocol, dispatcher, options and queue as properties being used to consolidate a event related things
 */

private class ListenerDispatcherHelper {
    var eventType: AnyClass!
    weak var listenerObject: ListenerDispatcherProtocol?
    weak var dispatcher: ListenerDispatcher?
    var options: ListenersDispatcherOptions?
    weak var queue: OperationQueue?
}

/**
    This class contains methods for adding any class as a listener for some eventType on a particular queue.
    When this event is being fired from some place in app this will call didFireEvent method being implemented by listener class and perform some action on it
 */
class ListenerDispatcher {
    private var listenerTable = NSMapTable<AnyObject, AnyObject>()
    private var _defaultQueue: OperationQueue?
    private var throttleHelper: ListenerDispatcherThrottleHelper?
    
    static let shared = ListenerDispatcher()
    
    init() {
        listenerTable = NSMapTable<AnyObject, AnyObject>.strongToStrongObjects()
        throttleHelper = ListenerDispatcherThrottleHelper.init(delegate: self)
    }
    
    func defaultQueue() -> OperationQueue {
        if _defaultQueue == nil {
            _defaultQueue = OperationQueue.init()
        }
        return _defaultQueue!
    }
    
    // MARK: add listener mothods
    
    func addListener(_ listener: ListenerDispatcherProtocol, eventType: AnyClass) {
        addListener(listener, eventType: eventType, self.defaultQueue())
    }
    
    func addListener(_ listener: ListenerDispatcherProtocol, options: ListenersDispatcherOptions?, eventType: AnyClass) {
        addListener(listener, options, eventType: eventType, queue: self.defaultQueue())
    }
        
    func addListener(_ listener: ListenerDispatcherProtocol, eventType: AnyClass, _ queue: OperationQueue) {
        addListener(listener, nil, eventType: eventType, queue: queue)
    }
    
    func addListener(_ listener: ListenerDispatcherProtocol, _ options: ListenersDispatcherOptions?, eventType: AnyClass, queue: OperationQueue) {
        let helper: ListenerDispatcherHelper = ListenerDispatcherHelper.init()
        helper.dispatcher = self
        helper.listenerObject = listener
        helper.eventType = eventType
        helper.options = options
        helper.queue = queue
        
        var helperArray = [ListenerDispatcherHelper]()
        
        if let array = listenerTable.object(forKey: listener as AnyObject) as? [ListenerDispatcherHelper] {
            helperArray = array
        }
        
        var updatedHelperArray: [ListenerDispatcherHelper] = [ListenerDispatcherHelper]()
        if helperArray.isEmpty {
            updatedHelperArray = helperArray
        }
        updatedHelperArray.append(helper)
        listenerTable.setObject(updatedHelperArray as AnyObject, forKey: listener as AnyObject)
    }
    
    // MARK: remove listener method
    
    func removeListener(_ listener: ListenerDispatcherProtocol) {
        if listenerTable.object(forKey: listener as AnyObject) != nil {
            listenerTable.removeObject(forKey: listener as AnyObject)
        }
    }
    
    // MARK: fire event methods
    
    func fire(event: AnyObject) {
        let listenerEnumerator = listenerTable.objectEnumerator()
        for helperArray in (listenerEnumerator?.allObjects)! where helperArray is [ListenerDispatcherHelper] {
            if let array = helperArray as? [ListenerDispatcherHelper] {
                for dispatcherHelper in array where type(of: event) == dispatcherHelper.eventType {
                    dispatcherHelper.listenerObject?.didFireEventWithDispatcher(self, withEvent: event )
                }
            }
        }
    }
    
    func fireEventNow(_ event: AnyObject, includeListenersIgnoringThrottling: Bool, includeListenersNotIgnoringThrottling: Bool) {
        let listenerEnumerator = listenerTable.objectEnumerator()

        for helperArray in (listenerEnumerator?.allObjects)! {
            
            if let array = helperArray as? [ListenerDispatcherHelper] {
            
                for dispatcherHelper in array where type(of: event) == dispatcherHelper.eventType {

                    let ignoresThrottling: Bool = dispatcherHelper.options != nil ? (dispatcherHelper.options?.isIgnoreThrottling)! : true
                    
                    let shouldSend: Bool = ignoresThrottling ? includeListenersIgnoringThrottling : includeListenersNotIgnoringThrottling
                    
                    if shouldSend {
                        dispatcherHelper.queue?.addOperation({[unowned self] () -> Void in
                            dispatcherHelper.listenerObject?.didFireEventWithDispatcher(self, withEvent: event)
                        })
                    }
                }
            }
        }
    }
    
    // MARK: throttle helpers
    
    func setThrottle(_ throttleValue: TimeInterval, forEventType eventType: AnyClass) {
        throttleHelper?.setThrottle(throttleValue, forEventType: eventType)
    }
    
    func throttle(forEventType eventType: AnyClass) -> TimeInterval {
        return throttleHelper != nil ? (throttleHelper?.throttle(forEventType: eventType))! : 0
    }
    
    func removeThrottle(forEventType eventType: AnyClass) {
        throttleHelper?.removeThrottle(forEventType: eventType)
    }
}

extension ListenerDispatcher: ListenersDispatcherThrottleHelperDelegate {
    
    func listenersDispatcherThrottleHelper(_ helper: ListenerDispatcherThrottleHelper, shouldDeliverEvent event: AnyObject) {
        self.fireEventNow(event, includeListenersIgnoringThrottling: false, includeListenersNotIgnoringThrottling: true)
    }
}
