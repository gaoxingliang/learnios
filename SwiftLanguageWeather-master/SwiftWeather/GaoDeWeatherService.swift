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
    let dic:Dictionary<String,[Int]>=["晴":[800],
                                      "多云":[804],
                                      "阴":[804],
                                      "阵雨":[701],
                                      "雷阵雨": [531],
                                      "雷阵雨并伴有冰雹":[906],
                                      "雨夹雪":[601],
                                      "小雨":[601],
                                      "中雨":[601],
                                      "大雨":[312],
                                      "暴雨":[312],
                                      "大暴雨":[312],
                                      "特大暴雨":[312],
                                      "阵雪":[621],
                                      "小雪":[903],
                                      "中雪":[621],
                                      "大雪":[621],
                                      "暴雪":[621],
                                      "雾":[741],
                                      "冻雨":[302],
                                      "沙尘暴":[900],
                                      "小雨-中雨":[601],
                                      "中雨-大雨":[601,312],
                                      "大雨-暴雨":[312],
                                      "暴雨-大暴雨":[312],
                                      "大暴雨-特大暴雨":[312],
                                      "小雪-中雪":[903,621],
                                      "中雪-大雪":[621],
                                      "大雪-暴雪":[621],
                                      "浮尘":[731],
                                      "扬沙":[711],
                                      "强沙尘暴":[731,957],
                                      "飑":[902],
                                      "龙卷风":[900],
                                      "弱高吹雪":[621],
                                      "轻雾":[741],
                                      "霾":[731]
    ];
    
    
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
    
    /**
     {
     "status": "1",
     "count": "1",
     "info": "OK",
     "infocode": "10000",
     "forecasts": [
     {
     "city": "中西区",
     "adcode": "810001",
     "province": "香港",
     "reporttime": "2017-12-15 18:00:00",
     "casts": [
     {
     "date": "2017-12-16",
     "week": "6",
     "dayweather": "多云",
     "nightweather": "多云",
     "daytemp": "16",
     "nighttemp": "13",
     "daywind": "无风向",
     "nightwind": "无风向",
     "daypower": "≤3",
     "nightpower": "≤3"
     },
     .....
     ]
     }
     ]
     }
     */
    fileprivate func getFirstFourForecastsForGaoDe(_ json: JSON) -> [Forecast] {
        var forecasts: [Forecast] = []
        if json["status"].stringValue == "1" && json["infocode"].stringValue == "10000" {
            // it's ok...
            let casts = json["forecasts"][0]["casts"]
            for index in 0...3 {
                let dayWeather = casts[index]
                let date = dayWeather["date"]
                let days = date.stringValue.split(separator: "-") // will be 2017-11-12
                let forcastIconText = self.getIconTextByTempDescriptionString(currentWeather: dayWeather["dayweather"].stringValue, iconString: "d")
                let forecast = Forecast(time: days[1] + "-" + days[2],
                                        iconText: forcastIconText,
                                        temperature: dayWeather["daytemp"].stringValue +  "\u{f03c}")
                 forecasts.append(forecast)
            }
        }
        else {
            for index in 0...3 {
                
                let forecast = Forecast(time: "00",
                                        iconText: "0",
                                        temperature: "0")
                
                forecasts.append(forecast)
            }
        }
        
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
        
        
        let queryGeoTask = session.dataTask(with: geoUrl) { (geoData, response, geoErr) in
            // Check network error
            guard geoErr == nil else {
                let error = SWError(errorCode: .networkRequestFailed)
                completionHandler(nil, error)
                return
            }
            
            print("geo result data" + Base64.base64Decoding(rawData: geoData!))
            // Check JSON serialization error
            guard let data = geoData else {
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
                
                
                /**
                 当前天气:
                 {
                 "status": "1",
                 "count": "1",
                 "info": "OK",
                 "infocode": "10000",
                 "lives": [
                 {
                 "province": "香港",
                 "city": "中西区",
                 "adcode": "810001",
                 "weather": "多云",
                 "temperature": "18",
                 "winddirection": "西北",
                 "windpower": "7",
                 "humidity": "77",
                 "reporttime": "2017-12-16 00:00:00"
                 }
                 ]
                 }
                */
                let queryCurrentWeatherTask = queryCurrentWeatherSession.dataTask(with: queryCurrentWeatherUrl) { (curData, response2, curErr) in
                    // Check network error
                    guard curErr == nil else {
                        let error = SWError(errorCode: .networkRequestFailed)
                        completionHandler(nil, error)
                        return
                    }
                    print("data for current weather is " + Base64.base64Decoding(rawData: curData!))
                    
                    // Check JSON serialization error
                    guard let currentWeatherData = curData else {
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
                    print("Current Weather is - " + currentWeather + " temp is " + currentTemp)
                    
                    var weatherBuilder = WeatherBuilder()
                    
                    weatherBuilder.temperature = currentTemp +  "\u{f03c}"
                    weatherBuilder.location = locationString
                    
                    
                    // 判断当前是白天还是晚上
                    let date = Date() // save date, so all components use the same date
                    let calendar = Calendar.current // or e.g. Calendar(identifier: .persian)
                    
                    let hour = calendar.component(.hour, from: date)
                    var iconStringFlag = "d" // 白天
                    if hour>=20 && hour<=6 {
                        iconStringFlag = "n"
                    }
                    weatherBuilder.iconText = self.getIconTextByTempDescriptionString(currentWeather: currentWeather, iconString: iconStringFlag)
                    
                    
                    // 访问预测的天气
                    
                    let queryForcastWeatherSession = URLSession(configuration: URLSessionConfiguration.default)
                    // continue to get the current weather
                    guard let queryForcastWeatherUrl = self.generateGetWeatherURL(adCode, extensions: "all") else {
                        let error = SWError(errorCode: .urlError)
                        completionHandler(nil, error)
                        return
                    }
                    
                    let queryForcastWeatherTask = queryForcastWeatherSession.dataTask(with: queryForcastWeatherUrl) { (forcastData, forcastResp, forcastErr) in
                        // Check network error
                        guard forcastErr == nil else {
                            let error = SWError(errorCode: .networkRequestFailed)
                            completionHandler(nil, error)
                            return
                        }
                        print("data for forcast weather is " + Base64.base64Decoding(rawData: forcastData!))
                        
                        // Check JSON serialization error
                        guard let forcastWeatherData = forcastData else {
                            let error = SWError(errorCode: .jsonSerializationFailed)
                            completionHandler(nil, error)
                            return
                        }
                        
                        guard let jsonForForcaseWeather = try? JSON(data: forcastWeatherData) else {
                            let error = SWError(errorCode: .jsonParsingFailed)
                            completionHandler(nil, error)
                            return
                        }
                        
                        weatherBuilder.forecasts = self.getFirstFourForecastsForGaoDe(jsonForForcaseWeather)
                        
                        completionHandler(weatherBuilder.build(), nil)
                    }
                    queryForcastWeatherTask.resume();
                }
                queryCurrentWeatherTask.resume();
                
            } else {
                let error = SWError(errorCode: .failToQueryGeo)
                completionHandler(nil, error)
            }
            
        }
        queryGeoTask.resume()
        
    }
    
    // currentWeather
    // iconString : n or d n -> 晚上  d -> 白天
    func getIconTextByTempDescriptionString(currentWeather : String, iconString : String) -> String {
        var intWeatherIcons = self.dic[currentWeather]
        var intWeatherIcon = 900 // 龙卷风 不应该是这个才对...
        if intWeatherIcons == nil {
            // not mapped yet...
            intWeatherIcon = 900
        } else {
            intWeatherIcon = intWeatherIcons![0];
        }
        var string = "\(intWeatherIcon)"
        print("The weather icon is " + string)
        let weatherIcon = WeatherIcon(condition: intWeatherIcon, iconString: "n")
        return weatherIcon.iconText
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
    

}

