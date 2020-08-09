//
//  ProfileViewModel.swift
//  ShowTime
//
//  Created by כפיר פנירי on 22/06/2020.
//  Copyright © 2020 Kfir & ShowTime. All rights reserved.
//

import Foundation

enum ProfileViewModelType {
    case info, logout
}

struct ProfileViewModel {
    let viewModelType: ProfileViewModelType
    let title: String
    let handler: (() -> Void)?
}
