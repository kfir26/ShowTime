//
//  ConversationModels.swift
//  ShowTime
//
//  Created by כפיר פנירי on 22/06/2020.
//  Copyright © 2020 Kfir & ShowTime. All rights reserved.
//

import Foundation

struct Conversation {
    let id: String
    let name: String
    let otherUserEmail: String
    let latestMessage: LatestMessage
}

struct LatestMessage {
    let date: String
    let text: String
    let isRead: Bool
}
