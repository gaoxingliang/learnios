//
//  GaoDeWeatherService.swift
//  SwiftWeather
//
//  Created by edward.gao on 12/12/2017.
//  Copyright © 2017 Jake Lin. All rights reserved.
//
//
// Created by Jake Lin on 9/2/15.
// Copyright (c) 2015 Jake Lin. All rights reserved.
//

import Foundation
import CoreLocation

import SwiftyJSON

struct GaoDeWeatherService: WeatherServiceProtocol {
    
    // http://lbs.amap.com/api/webservice/guide/api/weatherinfo  -> 这个是中文可以返回的
    // https://erikflowers.github.io/weather-icons/api-list.html -> 这个是对应的列表
    // https://www.zybang.com/question/d16782515d7e9cffa59745649569e3a0.html
    // 映射对应的中文可能返回的天气到weathericons
    let dic:Dictionary<String,Int>=["晴":800,
                                       "多云":804,
                                       "阴":804,
                                       "阵雨":701,
                                       "雷阵雨": 531];
    
    
    fileprivate let key = "69e8126da1e767758d6e3a2c8f30c806"
    fileprivate let queryGeoUrlPath = "http://restapi.amap.com/v3/geocode/regeo"
    fileprivate let queryWeatherUrlPath = "http://restapi.amap.com/v3/weather/weatherInfo"
    fileprivate func getFirstFourForecasts(_ json: JSON) -> [Forecast] {
        var forecasts: [Forecast] = []
        
        for index in 0...3 {
            guard let forecastTempDegrees = json["list"][index]["main"]["temp"].double,
                let rawDateTime = json["list"][index]["dt"].double,
                let forecastCondition = json["list"][index]["weather"][0]["id"].int,
                let forecastIcon = json["list"][index]["weather"][0]["icon"].string else {
                    break
            }
            
            let country = json["city"]["country"].string
            let forecastTemperature = Temperature(country: country!,
                                                  openWeatherMapDegrees: forecastTempDegrees)
            let forecastTimeString = ForecastDateTime(rawDateTime).shortTime
            let weatherIcon = WeatherIcon(condition: forecastCondition, iconString: forecastIcon)
            let forcastIconText = weatherIcon.iconText
            
            let forecast = Forecast(time: forecastTimeString,
                                    iconText: forcastIconText,
                                    temperature: forecastTemperature.degrees)
            
            forecasts.append(forecast)
        }
        
        return forecasts
    }
    
    func retrieveWeatherInfo(_ location: CLLocation, completionHandler: @escaping WeatherCompletionHandler) {
        
        
        
        guard let geoUrl = generateGetGeoURL(location) else {
            let error = SWError(errorCode: .urlError)
            completionHandler(nil, error)
            return
        }
        
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        
        
        let queryGeoTask = session.dataTask(with: geoUrl) { (data, response, error) in
            // Check network error
            guard error == nil else {
                let error = SWError(errorCode: .networkRequestFailed)
                completionHandler(nil, error)
                return
            }
            
            print("data" + data!.base64EncodedString())
            
            // Check JSON serialization error
            guard let data = data else {
                let error = SWError(errorCode: .jsonSerializationFailed)
                completionHandler(nil, error)
                return
            }
            
            guard let json = try? JSON(data: data) else {
                let error = SWError(errorCode: .jsonParsingFailed)
                completionHandler(nil, error)
                return
            }
            
            if json["status"].stringValue == "1" {
                
                // status 1 indicates it's ok
                let adCode = json["regeocode"]["addressComponent"]["adcode"].stringValue
                print("Start query weather for ad - " + adCode)
                var locationString = json["regeocode"]["addressComponent"]["streetNumber"]["street"].stringValue
                if locationString == nil || locationString == "" {
                    locationString = json["regeocode"]["formatted_address"].stringValue
                }
                
                // continue to get the current weather
                guard let queryCurrentWeatherUrl = self.generateGetWeatherURL(adCode, extensions: "base") else {
                    let error = SWError(errorCode: .urlError)
                    completionHandler(nil, error)
                    return
                }
                
     
                let queryCurrentWeatherSession = URLSession(configuration: URLSessionConfiguration.default)
                
                let queryCurrentWeatherTask = queryCurrentWeatherSession.dataTask(with: queryCurrentWeatherUrl) { (data2, response2, error2) in
                    // Check network error
                    guard error2 == nil else {
                        let error = SWError(errorCode: .networkRequestFailed)
                        completionHandler(nil, error)
                        return
                    }
                    print("data for current weather is " + self.base64Decoding(encodedString: data2!.base64EncodedString()))
                    
                    // Check JSON serialization error
                    guard let currentWeatherData = data2 else {
                        let error = SWError(errorCode: .jsonSerializationFailed)
                        completionHandler(nil, error)
                        return
                    }
                    
                    guard let jsonForCurrentWeather = try? JSON(data: currentWeatherData) else {
                        let error = SWError(errorCode: .jsonParsingFailed)
                        completionHandler(nil, error)
                        return
                    }
                    
                    let currentTemp = jsonForCurrentWeather["lives"][0]["temperature"].stringValue
                    let currentWeather = jsonForCurrentWeather["lives"][0]["weather"].stringValue
                    var intWeatherIcon = self.dic[currentWeather]
                    if intWeatherIcon == nil {
                        // not mapped yet...
                        intWeatherIcon = 800
                    }
                    
                    // compose the weather
                    var weatherBuilder = WeatherBuilder()
                    
                    weatherBuilder.temperature = currentTemp +  "\u{f03c}"
                    weatherBuilder.location = locationString
                    
                    let weatherIcon = WeatherIcon(condition: intWeatherIcon!, iconString: "n")
                    weatherBuilder.iconText = weatherIcon.iconText
                    
                    weatherBuilder.forecasts = self.getFirstFourForecasts(jsonForCurrentWeather)
                    
                    completionHandler(weatherBuilder.build(), nil)
                }
                queryCurrentWeatherTask.resume();
                
            } else {
                let error = SWError(errorCode: .failToQueryGeo)
                completionHandler(nil, error)
            }
            
        }
        queryGeoTask.resume()
        
    }
    
    // extentions all -> 获取预测数据
    // extentions base -> 获取当前的数据
    fileprivate func generateGetWeatherURL(_ adCode: String, extensions: String) -> URL? {
        guard var components = URLComponents(string: queryWeatherUrlPath) else {
            return nil
        }
        
        components.queryItems = [URLQueryItem(name:"city", value: adCode),
                                 URLQueryItem(name:"key", value:key),
                                 URLQueryItem(name:"extensions", value:extensions)]
        
        return components.url
    }
    
    
    fileprivate func generateGetGeoURL(_ location: CLLocation) -> URL? {
        guard var components = URLComponents(string: queryGeoUrlPath) else {
            return nil
        }
        let latitude = String(location.coordinate.latitude)
        let longitude = String(location.coordinate.longitude)
        print("location is " + latitude + "," + longitude)
        components.queryItems = [URLQueryItem(name:"location", value: longitude + "," + latitude),
                                 URLQueryItem(name:"key", value:key),
                                 URLQueryItem(name:"extensions", value:"base")]
        
        return components.url
    }
    
    func test(chineseWeather:String) -> String {
            return ""
    }
    
    /// swift Base64处理
    /**
     *   编码
     */
    func base64Encoding(plainString:String)->String
    {
        
        let plainData = plainString.data(using: String.Encoding.utf8)
        let base64String = plainData?.base64EncodedString(options: NSData.Base64EncodingOptions.init(rawValue: 0))
        return base64String!
    }
    
    /**
     *   解码
     */
    func base64Decoding(encodedString:String)->String
    {
        let decodedData = NSData(base64Encoded: encodedString, options: NSData.Base64DecodingOptions.init(rawValue: 0))
        let decodedString = NSString(data: decodedData! as Data, encoding: String.Encoding.utf8.rawValue)! as String
        return decodedString
    }
}

