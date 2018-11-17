//
//  ViewController.swift
//  testUIMac
//
//  Created by Paulo Gonçalves on 16/11/2018.
//  Copyright © 2018 Paulo Gonçalves. All rights reserved.
//

import Cocoa
import IOBluetooth

class ViewController: NSViewController {

    let controller:VehiclesController =  VehiclesController()
    
    @IBOutlet weak var connectButton: NSButton!
    @IBOutlet weak var skullIDTextfield: NSTextField!
    @IBOutlet weak var truckIdTextfield: NSTextField!
    @IBOutlet weak var muscleIdTextField: NSTextField!
    @IBOutlet weak var outputTextField: NSTextField!
    
    
    @IBOutlet weak var muscleAccelaration: NSSlider!
    @IBOutlet weak var truckAceleration: NSSlider!
    @IBOutlet weak var skullAcelaration: NSSlider!
    
    @IBOutlet weak var muscleLaneSelector: NSSlider!
    @IBOutlet weak var truckLaneSelector: NSSlider!
    @IBOutlet weak var skulLaneSelector: NSSlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


    @IBAction func changeSpeed(_ sender: NSSlider) {
        print("Speed \(sender.floatValue) for carID: \(sender.tag)")
        
        let v:Vehicle = self.controller.findVehicle(byId: UInt32(sender.tag))
        v.setSpeed(sender.floatValue)
        self.appendInfo(msg: "Car:[\(sender.tag)] speed:\(sender.floatValue)")

    }
    
    
    @IBAction func changeLane(_ sender: NSSlider) {
        print("Lane \(sender.intValue)")
        //sender.integerValue = 30
        let v:Vehicle = self.controller.findVehicle(byId: UInt32(sender.tag))
        v.changeLane(sender.floatValue, andSpeed: UInt16(self.getAcelerationForID(sender.tag)))
        self.appendInfo(msg: "Car:[\(sender.tag)] lane:\(sender.floatValue) speed:\(self.getAcelerationForID(sender.tag))")
    }
    
    @IBAction func setLaneToMiddle(_ sender: NSButton) {
        switch sender.tag {
        case 200:
            self.muscleLaneSelector.intValue = 0
            self.changeLane(self.muscleLaneSelector)
            break
        case 210:
            self.truckLaneSelector.intValue = 0
            self.changeLane(self.truckLaneSelector)
            break
        case 220:
            self.skulLaneSelector.intValue = 0
            self.changeLane(self.skulLaneSelector)
            break
        default:
            print("wrong tag")
        }
    }
    
    
    @IBAction func connectToBluetooth(_ sender: NSButton) {
        switch sender.tag {
        case 100:
            self.controller.beginScan()
            self.appendInfo(msg: "Connects to bluetooth:")
            break
        case 110:
            self.searchVehicles()
            break
        default:
            print("wrong tag")
        }
    }
    
    
    func searchVehicles(){
        self.appendInfo(msg: "Vehicles:")
        for v in self.controller.vehicles {
            let veh:Vehicle = v as! Vehicle
            print(veh.identifier)
            self.assignCarModelToUI(veh)
            self.appendInfo(msg: "id:\(veh.identifier) model:\(veh.modelIdentifier)")
        }
    }
    
    func appendInfo(msg:String) {
        self.outputTextField.stringValue = self.outputTextField.stringValue+"\n"+msg
    }
    
    func assignCarModelToUI(_ v:Vehicle){
        switch v.modelIdentifier {
        case 9:
            self.skullIDTextfield.stringValue = "\(v.identifier)"
            self.skullAcelaration.tag = Int(v.identifier)
            self.skulLaneSelector.tag = Int(v.identifier)
            break
        case 19:
            self.muscleIdTextField.stringValue = "\(v.identifier)"
            self.muscleAccelaration.tag = Int(v.identifier)
            self.muscleLaneSelector.tag = Int(v.identifier)
            break
        case 18:
            self.truckIdTextfield.stringValue = "\(v.identifier)"
            self.truckAceleration.tag = Int(v.identifier)
            self.truckLaneSelector.tag = Int(v.identifier)
            break
        default:
            print("No car")
        }
    }
    
    func getAccelNSSliderForCar(_ id:Int) -> NSSlider{
        let accelSliderArray:[NSSlider] = [self.skullAcelaration,self.muscleAccelaration,self.truckAceleration]
        for nssld in accelSliderArray {
            if(id == nssld.tag){
                return nssld;
            }
        }
        return self.skullAcelaration
    }
    
    func getAcelerationForID(_ id:Int) -> Float {
        let acc:NSSlider = self.getAccelNSSliderForCar(id)
        return acc.floatValue
    }
    
}


