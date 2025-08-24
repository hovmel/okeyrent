//
//  LockManager.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 22.12.2022.
//

import Foundation
import CoreBluetooth

protocol LockManagerDelegate: AnyObject {
    func changeLockStatus(_ status: LockState)
    func didFinishAction(_ status: LockState)
    func didDisconnect()
    func didConnect()
    func didConnecting()
}

class LockManager: NSObject {
    
    static let shared = LockManager()
    
    weak var delegate: LockManagerDelegate?
    
    var progressState: LockState?
    var sninfo: String?
    
    var currentLockState: LockState? {
        didSet {
            guard let currentLockState = currentLockState else {return}
            if let progressState = self.progressState {
                if (currentLockState == .unLock && progressState == .locked) ||
                    (currentLockState == .locked && progressState == .unLock) {
                    self.progressState = nil
                    self.delegate?.didFinishAction(currentLockState)
                }
            }
            if oldValue != currentLockState {
                self.delegate?.changeLockStatus(currentLockState)
            }
        }
    }
    
    var lock: LockConfigModel? {
        didSet {
            if let lock = lock, oldValue?.serial != lock.serial {
                AirbnkSDK.initAirbnkSDK(lock.key)
                AirbnkSDK.connect(toLock: lock.serial)
                self.delegate?.didConnecting()
            } else {
                self.configLock()
            }
        }
    }
    
    private override init() {
        super.init()
        AirbnkSDK.handle(self)
    }
    
    func openLock() {
        self.progressState = .locked
        self.perform(#selector(self.openLockSDK), with: nil, afterDelay: 1.0)
    }
    
    func closeLock() {
        self.progressState = .unLock
        self.perform(#selector(self.closeLockSDK), with: nil, afterDelay: 1.0)
    }
    
    @objc private func openLockSDK() {
        if let serial = self.sninfo {
            AirbnkSDK.unlock(serial)
        }
    }
    
    @objc private func closeLockSDK() {
        if let serial = sninfo {
            AirbnkSDK.lock(serial)
        }
    }
    
    @objc func configLock() {
        AirbnkSDK.configLock(self.sninfo,
                             openDirection: self.lock?.directionID.value ?? 0,
                             autoLock: (self.lock?.autoCloseTime != 0) ? 1 : 0,
                             autoLockTime: ((self.lock?.autoCloseTime ?? 0)/10),
                             doorSensor: (self.lock?.autoCloseTime != 0) ? 1 : 0,
                             doorSensorAutoLockTime: ((self.lock?.autoCloseTime ?? 0)/10),
                             handRotation: 0,
                             latchTime: 0)
    }
    
}

extension LockManager: AirbnkSDKDelegate {
    func responeseLockStatus(_ state: LockState) {
        switch state {
        case .locked:
            print("lockManager: state is: locked")
        case .unLock:
            print("lockManager: state is: unLock")
        case .lockedOpen:
            print("lockManager: state is: lockedOpen")
        case .lockedClose:
            print("lockManager: state is: lockedClose")
        case .unLockOpen:
            print("lockManager: state is: unLockOpen")
        case .unLockClose:
            print("lockManager: state is: unLockClose")
        case .jammed:
            print("lockManager: state is: jammed")
        @unknown default:
            print("lockManager: state is unknown")
        }
        self.currentLockState = state
    }

    func didDisConnectLock(_ sninfo: String?) {
        print("lockManager: did disconnect")
        self.delegate?.didDisconnect()
    }
    
    func didConnectLock(_ sninfo: String?) {
        print("lockManager: did connect")
        self.sninfo = sninfo
        self.configLock()
//        self.perform(#selector(self.configLock), with: nil, afterDelay: 1.5)
        self.delegate?.didConnect()
    }
}
