//
//  ViewController.swift
//  BleTest
//
//  Created by sb_dev on 2022/12/12.
//

import UIKit
import CoreBluetooth


import FirebaseDatabase


class ViewController: UIViewController{
    
    var bluetoothManager:BluetoothManager? = nil
    let dataAnalyzer = BleDataAnalyzer()
    var dataCount : Int = 0
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var humiLabel: UILabel!
    @IBOutlet weak var freqLabel: UILabel!
    
    //=====================임시 테스트 소스=========================
    var ref: DatabaseReference!

    
    let userNotiCenter = UNUserNotificationCenter.current() // 추가
    // 사용자에게 알림 권한 요청
       func requestAuthNoti() {
           let notiAuthOptions = UNAuthorizationOptions(arrayLiteral: [.alert, .badge, .sound])
           userNotiCenter.requestAuthorization(options: notiAuthOptions) { (success, error) in
               if let error = error {
                   print(#function, error)
               }
           }
       }
    // 알림 전송
        func requestSendNoti(seconds: Double) {
            let notiContent = UNMutableNotificationContent()
            notiContent.title = "알림"
            notiContent.body = "다이어트 중입니다."
            notiContent.userInfo = ["targetScene": "splash"] // 푸시 받을때 오는 데이터
            notiContent.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "haha.mp3"))
                
            // 알림이 trigger되는 시간 설정
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: seconds, repeats: false)

            let request = UNNotificationRequest(
                identifier: UUID().uuidString,
                content: notiContent,
                trigger: trigger
            )

            userNotiCenter.add(request) { (error) in
                print(#function, error as Any)
            }

        }
    //========================================================
    override func viewDidLoad() {
        ref = Database.database().reference()
        
        requestAuthNoti()
        super.viewDidLoad()
        self.bluetoothManager = BluetoothManager.getInstance()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.bluetoothManager!.delegate = self
        if((self.bluetoothManager?.connectedPeripheral) != nil){
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                print("Constant.CMD_INIT_MODULE")
                self.sendProtocol(peripheral:  (self.bluetoothManager?.connectedPeripheral)! ,type: 0,cmd: Constant.CMD_INIT_MODULE, what: 0)
            }
        }
    }
    
    @IBAction func bleListAction(_ sender: Any) {
       
        let storyboard: UIStoryboard? = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let bleVc = storyboard?.instantiateViewController(identifier: "BleVC") else{return}
        bleVc.modalPresentationStyle = .fullScreen
        self.present(bleVc, animated: true)
    }
    func sendProtocol(peripheral:CBPeripheral,type:UInt8,cmd : UInt8,what :UInt8) -> Void{
        var data:[UInt8]=[]
        switch (cmd){
        case Constant.CMD_INIT_MODULE:
            data.append(Constant.STX)
            data.append(0)
            data.append(0)
            data.append(cmd)
            data.append(Constant.ETX)
            let writeData =  Data(data)
            bluetoothManager?.connectedPeripheral!.writeValue(writeData, for: (bluetoothManager?.mainCharacteristic!)!, type: .withResponse)
            break
        case Constant.CMD_SENSOR_TYPE:
      
            data = [Constant.STX,0,type,cmd,Constant.ETX]
            let writeData =  Data(data)
            bluetoothManager?.connectedPeripheral!.writeValue(writeData, for: (bluetoothManager?.mainCharacteristic!)!, type: .withResponse)
            //mMainActivity.setModuleState(MainActivity.CONNECT_STATE_TYPE);
            //mMainActivity.startWaitingForState();
            break
        case Constant.CMD_SEND_MODULE_DIRECTION:
            data.append(Constant.STX)
            data.append((what == 1 ? 1: 0))
            data.append(type)
            data.append(cmd)
            data.append(Constant.ETX)
            let writeData =  Data(data)
            bluetoothManager?.connectedPeripheral!.writeValue(writeData, for: (bluetoothManager?.mainCharacteristic!)!, type: .withResponse)
            break
        case Constant.CMD_COUNT_START:
            data = [Constant.STX, 0,0,cmd,Constant.ETX]
            let writeData =  Data(data)
            bluetoothManager?.connectedPeripheral!.writeValue(writeData, for: (bluetoothManager?.mainCharacteristic!)!, type: .withResponse)
            break
            
        default: break
            
        }
    }
    func recvDataSplit(values : [UInt8]) -> [UInt8]{
        var splitValue:[UInt8]=[]
        for i in (0 ... values.count-1).reversed(){
            if values[i] == Constant.ETX{
                splitValue = Array(values[0...i])
                break
            }
        }
        return splitValue
    }
}
extension ViewController : BluetoothDelegate{
    
    func didDiscoverServices(_ peripheral: CBPeripheral){
            for service in peripheral.services! {
                print("Service found with UUID: " + service.uuid.uuidString)
                if (service.uuid.uuidString == Constant.RECIEVE_DATA_SERVICE) {
                    self.bluetoothManager?.connectedPeripheral!.discoverCharacteristics(nil, for: service)
                    break
                }
            }
    }
    func didDiscoverCharacteritics(_ service: CBService, pripheral: CBPeripheral) {
        print("didDiscoverCharacteristicsFor")
        if (service.uuid.uuidString ==   Constant.RECIEVE_DATA_SERVICE) {
            for characteristic in service.characteristics! {
                if characteristic.uuid.uuidString == Constant.SEND_DATA_CHARACTERISTIC {
                    self.bluetoothManager?.connectedPeripheral!.setNotifyValue(true, for: characteristic)
                    self.bluetoothManager?.mainCharacteristic = characteristic
                    break
                }
            }
        }
    }
    func didReadValueForCharacteristic(_ characteristic: CBCharacteristic) {
        let time = getCurrentTime()
        if(dataCount % 5 == 0){
            self.ref.child("users").child("\(time)").setValue(["recvTime": time])
        }
        dataCount+=1
        
        

    }
    func getCurrentTime()->String{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let current_date_string = formatter.string(from: Date())
       return current_date_string
        
    }
    
    func didUpdateState(_ state: CBManagerState ) {
        switch state {
        case .resetting:
            print("MainController --> State : Resetting")
            
        case .poweredOn:
            print(" MainController -->State : poweredOn")
            
        case .poweredOff:
            print(" MainController -->State : Powered Off")
            
        case .unauthorized:
            print("MainController --> State : Unauthorized")
            
        case .unknown:
            print("MainController --> State : Unknown")
            
        case .unsupported:
            print("MainController --> State : Unsupported")
            
        @unknown default: break
            
        }
    }
    
}




