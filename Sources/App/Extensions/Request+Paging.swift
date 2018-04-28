//
//  Request+Paging.swift
//  App
//
//  Created by William McGinty on 4/27/18.
//

import Foundation
import Vapor
import Fluent

extension Request {
    
    struct Page {
        let count: Int
        let offset: Int
        
        var range: Range<Int> {
            return offset..<count+offset
        }
    }
    
    func getPageInformation() -> Page {
        return Page(count: (try? query.get(Int.self, at: "count")) ?? .max, offset: (try? query.get(Int.self, at: "offset")) ?? 0)
    }
    
    func getSortDirection() -> QuerySortDirection {
        return (try? query.get(Bool.self, at: "ascending")) ?? true ? .ascending : .descending
    }
}
