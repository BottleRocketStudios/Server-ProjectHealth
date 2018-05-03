//
//  LogMiddleware.swift
//  App
//
//  Created by Will McGinty on 5/3/18.
//

import Foundation
import Vapor
import Logging

final class LogMiddleware: Middleware, Service {

    //MARK: Properties
    private let log: Logger
    
    //MARK: Initializers
    init(log: Logger) {
        self.log = log
    }
    
    func respond(to request: Request, chainingTo next: Responder) throws -> EventLoopFuture<Response> {
        log.verbose("[\(Date())] \(request.http.method) \(request.http.url.path))")
        return try next.respond(to: request)
    }
}
