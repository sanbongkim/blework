//
//  Constant.swift
//  daview
//  Created by ksb on 06/08/2019.
//  Copyright © 2019 ksb. All rights reserved.

import UIKit
import CoreBluetooth
class Constant{
    
  
    
    
//    public static let SEND_DATA_SERVICE_UUID = "3A95E1B9-D1A2-4876-8335-02108039B3A2"
//    public static let SEND_DATA_CHARACTERISTIC = "3A95E1B9-D1A2-4876-8335-02108039B3A2"
//    public static let RECIEVE_DATA_CHARACTERISTIC = "3A95E1B8-D1A2-4876-8335-02108039B3A2"
    
    //Mark - 블루투스 CMD
    public static let CMD_INS_DATA_ACK  : UInt8 = 0xC1
    public static let CMD_INS_DATA_NOTIFY  : UInt8 = 0xF1
    public static let CMD_POZITION : UInt8 = 0xF1

    
    //테스트
    public static let SEND_DATA_SERVICE_TEST = "F000AA70-0451-4000-B000-000000000000"
    public static let SEND_DATA_CHARACTERISTIC = "F000AA72-0451-4000-B000-000000000000";
    public static let RECIEVE_DATA_SERVICE_TEST = "F000AA80-0451-4000-B000-000000000000";
    public static let RECIEVE_DATA_CHARACTERISTIC = "F000AA81-0451-4000-B000-000000000000";
    
    
    public static let STX : UInt8 = 0x02
    public static let ETX : UInt8 = 0x03
    public static let NAK : UInt8 = 0x15
    public static let ACK : UInt8 = 0x06
    public static let CMD_SENSOR_TYPE : UInt8 = 0x21
    public static let CMD_INIT_MODULE : UInt8 = 0x22
    public static let CMD_COUNT_START : UInt8 = 0x23
    public static let CMD_COUNT_STOP : UInt8 = 0x24
    public static let CMD_COUNT_RESULT : UInt8 = 0x26
    public static let CMD_CALIBRATION_GYRO_START : UInt8 = 0x27
    public static let CMD_CALIBRATION_GYRO_RESULT : UInt8 = 0x28
    public static let CMD_CALIBRATION_MAGNET_START : UInt8 = 0x29
    public static let CMD_SEND_CALIBRATION_GYRO : UInt8 = 0x30
    public static let CMD_SEND_CALIBRATION_SUCCESS : UInt8 = 0x32
    public static let CMD_SEND_CALIBRATION_MAGNET : UInt8 = 0x33
    public static let CMD_SEND_MODULE_DIRECTION : UInt8 = 0x36
    public static let CMD_COUNT_CPU_SLEEP : UInt8 = 0x2D
    public static let CMD_MAGNET_NEED_OR_NOT : UInt8 = 0x2E
    public static let CMD_POWER_RESULT : UInt8 = 0x2F
    public static let MUSIC_LEFT : Int = 0
    public static let MUSIC_RIGHT : Int = 1
    
}
