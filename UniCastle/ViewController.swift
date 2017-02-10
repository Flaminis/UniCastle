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
    var currentCourseCode = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        getAllCourses()
        // Do any additional setup after loading the view, typically from a nib.
    }

    func getCourseInfo(courseCode: String) -> Void{
        self.currentCourseCode = courseCode
        
        
        Alamofire.request("http://www.ncl.ac.uk/undergraduate/degrees/\(courseCode.lowercased())").responseString{ response in
            if let html = response.result.value {
                self.parseModulesOfCourse(html: html, courseCode: courseCode)
            }
        }
    }
    func parseModulesOfCourse(html: String, courseCode: String) -> Void {
        
        let course = Course()
        course.ucasCode = courseCode

        
        if let doc = Kanna.HTML(html: html, encoding: String.Encoding.utf8) {
            // Search for nodes by CSS selector
            for show in doc.css("a") {
                // Strip the string of surrounding whitespace.
                let showString = show.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                let pat = ".*[\\w]{3,}[\\d]{3,}.*"
                let matches = matchesForRegexInText(regex: pat, text: showString)
                let patternForCode = "[\\w]{3,}[\\d]{3,}"
                var matchesForCodes = matchesForRegexInText(regex: patternForCode, text: showString)
                if (matches.count>0){
                    course.modules.append(matches[0])
                }
                if (matchesForCodes.count>0){
//                    print(matchesForCodes[0])
//                    print(courseCode)
                    course.moduleCodes.append(matchesForCodes[0])
                }
                }
             for show in doc.css(".widget-aux") {
                let showString = show.toHTML!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                let pat = "media.*\\.jpg"
                let matches = matchesForRegexInText(regex: pat, text: showString)
                if (matches.count>0){
                    let imageUrl = matches[0]
                    course.imageUrl = "http://www.ncl.ac.uk/\(imageUrl)"
                }
            }
            for show in doc.css(".pageTitle") {
                let showString = show.toHTML!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                let pat = ".* Honours"
                let matches = matchesForRegexInText(regex: pat, text: showString)
                if (matches.count>0){
                    let courseName = matches[0]
                    
                    course.courseName = courseName.replacingOccurrences(of: "<h1>", with: "")
                }
            }
        }
        course.saveInBackground()
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
                    print(matchesForCodes[0])
                    }
                }
            }
            let uniqueList = Array(Set(courseListCodes))
            for index in 0...uniqueList.endIndex-1{
                self.getCourseInfo(courseCode: uniqueList[index].lowercased())
            }
            
            
    }
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




