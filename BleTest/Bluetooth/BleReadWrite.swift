//
//  BleReadWrite.swift
//  BleTest
//
//  Created by sb_dev on 2022/12/23.
//

import Foundation
import CoreBluetooth

extension BluetoothManager{
    
    public func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        print("Bluetooth Manager --> didUpdateValueForCharacteristic")
        if error != nil {
            print("Bluetooth Manager --> Failed to read value for the characteristic. Error:\(error!.localizedDescription)")
            delegate?.didFailToReadValueForCharacteristic?(error!)
            return
        }
        
        delegate?.didReadValueForCharacteristic?(characteristic)
    }
    
}
