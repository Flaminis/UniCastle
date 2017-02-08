//
//  ViewController.swift
//  UniCastle
//
//  Created by Yerbol Kopzhassar on 04/02/2017.
//  Copyright © 2017 Yerbol Kopzhassar. All rights reserved.
//

import UIKit
import Kanna
import Alamofire
class ViewController: UIViewController {
    
    var courseList = [""]
    var courseListCodes = [""]
    var moduleList = [""]
    var moduleListCodes = [""]
    override func viewDidLoad() {
        super.viewDidLoad()
        getAllCourses()
        // Do any additional setup after loading the view, typically from a nib.
    }

    func getCourseModules(courseCode: String) -> Void{
        print(courseCode)
        
    
    
    
        
        Alamofire.request("http://www.ncl.ac.uk/undergraduate/degrees/\(courseCode.lowercased())").responseString{ response in
            print("\(response.result.isSuccess)")
            if let html = response.result.value {
                self.parseModulesOfCourse(html: html as! String)
            }
        }
    }
    func parseModulesOfCourse(html: String) -> Void {
        if let doc = Kanna.HTML(html: html, encoding: String.Encoding.utf8) {
            
            // Search for nodes by CSS selector
            for show in doc.css("a") {
                print(show.text)
                // Strip the string of surrounding whitespace.
                let showString = show.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                let pat = ".*[\\w]{3,}[\\d]{3,}.*"
                let matches = matchesForRegexInText(regex: pat, text: showString)
                let patternForCode = "[\\w]{3,}[\\d]{3,}"
                var matchesForCodes = matchesForRegexInText(regex: patternForCode, text: showString)
                
                if (matches.count>0){
                    moduleList.append(matches[0])
                }
                if (matchesForCodes.count>0){
                        moduleListCodes.append(matchesForCodes[0])
                }
            }
        }
    
    
    
    }
    
    
    
    
    
    func getAllCourses() -> Void {
        Alamofire.request("http://www.ncl.ac.uk/undergraduate/degrees/#subject").responseString { response in
            print("\(response.result.isSuccess)")
            if let html = response.result.value {
                self.parseCourses(html: html)
            }
        }
    }
    
    
    func parseCourses(html: String) -> Void {
        if let doc = Kanna.HTML(html: html, encoding: String.Encoding.utf8) {
            
            // Search for nodes by CSS selector
            for show in doc.css("li") {
                
                // Strip the string of surrounding whitespace.
                let showString = show.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                let pat = ".+[\\w\\d]+.*"
                let matches = matchesForRegexInText(regex: pat, text: showString)
                let patternForCode = "\\([\\w\\d]+\\)"
                var matchesForCodes = matchesForRegexInText(regex: patternForCode, text: showString)

                if (matches.count>0){
                    courseList.append(matches[0])
                }
                if (matchesForCodes.count>0){
                if (matchesForCodes[0].characters.count >= 5){
                    
                    matchesForCodes[0] = matchesForCodes[0].replacingOccurrences(of: "(", with: "")
                     matchesForCodes[0] = matchesForCodes[0].replacingOccurrences(of: ")", with: "")
                    courseListCodes.append(matchesForCodes[0])

                    }
                }
            }
        }
        getCourseModules(courseCode: "h652")
    }
    
    func matchesForRegexInText(regex: String, text: String) -> [String] {
        
        do {
            let regex = try NSRegularExpression(pattern: regex, options: [])
            let nsString = text as NSString
            let results = regex.matches(in: text,
                                                options: [], range: NSMakeRange(0, nsString.length))
            return results.map { nsString.substring(with: $0.range)}
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
    
    }




