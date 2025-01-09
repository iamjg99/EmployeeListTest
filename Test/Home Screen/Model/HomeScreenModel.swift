//
//  HomeScreenModel.swift
//  Test
//
//  Created by Jatin Gupta on 09/01/25.
//

import Foundation

struct EmployeeResponse: Codable {
    let status: String?
    let data: [Employee]?
    let message: String?
}

struct Employee: Codable, Identifiable {
    let id: Int
    let employeeName: String?
    let employeeSalary: Int?
    let employeeAge: Int?
    let profileImage: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case employeeName = "employee_name"
        case employeeSalary = "employee_salary"
        case employeeAge = "employee_age"
        case profileImage = "profile_image"
    }
}
