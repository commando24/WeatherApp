//
//  UtilityClass.swift
//  WeatherApp
//
//  Created by Surjeet Rajput on 23/02/21.
//

import UIKit

class UtilityClass: NSObject {

    static let shared = UtilityClass()
    
    func getTemperatureString(_ temperature: Double, fromInputUnit input: UnitTemperature, toOutputUnit output: UnitTemperature) -> String {
        let celsius = self.convertTemperature(temp: temperature, from: .kelvin, to: .celsius)
        let measurementFormatter = MeasurementFormatter()
        let measurement = Measurement(value: celsius, unit: output)
        return measurementFormatter.string(from: measurement)
    }
    
    func convertTemperature(temp: Double, from inputTempType: UnitTemperature, to outputTempType: UnitTemperature) -> Double {
        let input = Measurement(value: temp, unit: inputTempType)
        let output = input.converted(to: outputTempType)
        return output.value
    }
    
    
}
