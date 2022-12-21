//
//  BleDataAnalayer.swift
//  BleTest
//
//  Created by sb_dev on 2022/12/13.
//

import Foundation
import CoreBluetooth

class BleDataAnalyzer:NSObject{
    
    func analyzer(_ characteristic: CBCharacteristic) -> InsDataModel {
        let value = Array<UInt8>(characteristic.value!)
        switch(value[4]){
        case Constant.CMD_INS_DATA_NOTIFY:
            let vindex = getUInt32(values: value, arrayIndex: 6)
            let vfrequency = getUInt32(values: value, arrayIndex: 10)
            let vtemp = getUInt16(values: value, arrayIndex: 14)
            let vhumid = getUInt16(values: value, arrayIndex: 16)
            return InsDataModel(index: vindex, frequency: vfrequency, temp: vtemp, humid: vhumid)
       
        default:
          return  InsDataModel(index: 0, frequency: 0, temp: 0, humid: 0)
        }
      
    }
    public func getUInt32(values : [UInt8], arrayIndex : Int) -> UInt32{
        let returnValue = UInt32(values[arrayIndex]) << 24      |
        UInt32(values[arrayIndex + 1]) << 16  |
        UInt32(values[arrayIndex + 2]) << 8   |
        UInt32(values[arrayIndex + 3])
        return returnValue
    }
    public func getUInt16(values : [UInt8], arrayIndex : Int) -> UInt16 {
        let returnValue =  UInt16(values[arrayIndex]) << 8   |
        UInt16(values[arrayIndex + 1])
        return returnValue
    }
}
