//
//  StructToJson.swift
//  MedicalApp
//
//  Created by Apple on 12/12/16.
//  Copyright © 2016 vijayvirSingh. All rights reserved.
//

import Foundation
import UIKit


protocol JSONRepresentable
{
    var jsonStruct : AnyObject
        {
        get
    }
}


protocol StructJSONSerializable : JSONRepresentable
{
    
}

extension StructJSONSerializable
{
    var jsonStruct: AnyObject
    {
        var representation = [String: AnyObject]()
        
        
        for case let (label?, value) in Mirror(reflecting: self).children
        {
            
            
            switch value
            {
            case let value as JSONRepresentable:
                //  print(type(of: value) , label  , type(of: value.jsonStruct ))
                representation[label] = value.jsonStruct
                
            case let value as AnyObject:
                // print("***************  ",type(of: value) , label )
                
                representation[label] = value
                
            default:
                
                break
            }
        }
        
        return representation as AnyObject
    }
    
    
   
    
    func toJsonObect() -> AnyObject
    {
        let jsonString = self.toJsonString()
        
        let data: NSData = jsonString!.data(using: String.Encoding.utf8)! as NSData
        
    //    _: NSError?
        
        do {
            if let dictionaryOK = try JSONSerialization.jsonObject(with: data as Data, options: []) as? AnyObject
            {
       
                return dictionaryOK
                // parse JSON
            }
        } catch
        {
            print(error)
        }
        
      //let jsonObject: AnyObject? =   JSONSerialization.JSONObjectWithData(data as Data, options: .readingOptions.allZeros) as AnyObject!
        
        
        
      //  a(data,     options: JSONSerialization.ReadingOptions.allZeros, error: &error)

        
        return "sdd" as AnyObject
    }
    
    func toJsonString() -> String?
    {
        
        guard JSONSerialization.isValidJSONObject(jsonStruct) else
        {
            print("not a proper Json")
            return nil
        }
        
        do {
            
            
            let  data = try JSONSerialization.data(withJSONObject: jsonStruct, options: [])
            
            
            
            
            return String(data: data, encoding: String.Encoding.utf8)
        } catch {
            return nil
        }
    }
    
    func toEncodingURLStr() -> String?
    {
        let jsonObject = self.toJsonObect() as! [String : String]
        
        let strEnove = jsonObject.map { $0.key + "=" + ($0.value.addingPercentEncoding( withAllowedCharacters: NSCharacterSet.urlQueryAllowed))! }
        
         let some =    strEnove.reduce("") { $0.isEmpty ? $1 : $0 + "&" + $1}
        
   
        
        return some
        
    }
    
}



extension Date: StructJSONSerializable
{
    
    var jsonStruct: AnyObject
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        return formatter.string(from: self) as AnyObject
    }
    
}


/*
 
 
 struct  Family : StructJSONSerializable
 {
    var mother: String
    var father: String
 }
 
 struct Owner : StructJSONSerializable
 {
    var name: String
    var timestamp: Date
    var phoneNumbers : [String]
    var dob : [String : String]
 
     -> var family: Family
 
 
 }
 
 struct Car: StructJSONSerializable
 {
    var manufacturer: String
    var model: String
    var mileage: Float
    
    -> var owner: Owner
 
 }
 
 var car = Car(
                manufacturer: "Tesla", model: "Model T",
                mileage: 1234.56,
                owner: Owner(
                            name: "Emial" ,
                            timestamp: Date(),
                            phoneNumbers : ["7896544","45632178"] ,
                            dob :  ["month":"11" , "date":"30 " ],
                            family :Family(mother: "Dad", father: "Mom")
                            )
 )
 
 
 car.model = "Maruti"
 
 
 
 if let json   = car.toJsonString()
 {
 print(car)
 // print("asdd", type(of: json) , json)
 
 
 }

 
 
 */

