//
//  TopHeadlinesData.swift
//  BreakingNews
//
//  Created by Julian Astrada on 07/07/2020.
//  Copyright © 2020 Julian Astrada. All rights reserved.
//

import UIKit

struct TopHeadlinesData: Codable {
    var articles: [Article]
}

struct Article: Codable {
    var author: String?
    var title: String?
    var description: String?
    var url: String?
}
