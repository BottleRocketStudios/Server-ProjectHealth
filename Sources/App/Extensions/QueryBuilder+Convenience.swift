//
//  QueryBuilder+Convenience.swift
//  App
//
//  Created by William McGinty on 4/27/18.
//

import Foundation
import Vapor
import Fluent
import FluentSQLite

//MARK: Paging
extension QueryBuilder {

    func paged(to page: Request.Page) -> Self {
        return self.range(page.range)
    }
}

//MARK: Timestamp Sorting
extension QueryBuilder where Model: Timestampable {
    
    func sortedByCreation(in direction: QuerySortDirection = .ascending) throws -> Self {
        return try sort(\.fluentCreatedAt, direction)
    }
    
    func sortedByUpdate(in direction: QuerySortDirection = .ascending) throws -> Self {
        return try sort(\.fluentUpdatedAt, direction)
    }
}

//MARK: Parent Filtering
extension QueryBuilder where Model: ParentRetrievable {

    func whereParent(has uuid: UUID?) throws -> Self {
        return try filter(.parent(has: uuid))
    }
}

private extension ModelFilter where M: ParentRetrievable {
    
    static func parent(has uuid: UUID?) throws -> ModelFilter<M> {
        return try ModelFilter(filter: QueryFilter(field: M.parentIDKey.makeQueryField(), type: .equals, value: QueryFilterValue.data(uuid)))
    }
}
