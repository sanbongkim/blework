//
//  Constant.swift
//  daview
//  Created by ksb on 06/08/2019.
//  Copyright © 2019 ksb. All rights reserved.

import UIKit
import CoreBluetooth
class Constant{
    
    public static let SEND_DATA_SERVICE_UUID = "3A95E1B9-D1A2-4876-8335-02108039B3A2"
    public static let SEND_DATA_CHARACTERISTIC = "3A95E1B9-D1A2-4876-8335-02108039B3A2"
    public static let RECIEVE_DATA_CHARACTERISTIC = "3A95E1B8-D1A2-4876-8335-02108039B3A2"
    
    //Mark - 블루투스 CMD
    public static let CMD_INS_DATA_ACK  : UInt8 = 0xC1
    public static let CMD_INS_DATA_NOTIFY  : UInt8 = 0xF1
    public static let CMD_POZITION : UInt8 = 0xF1

}
