//
//  CacheControlMiddleware.swift
//  App
//
//  Created by Will McGinty on 5/2/18.
//

import Foundation
import Vapor
import HTTP

class CacheControlMiddleware: Middleware {
    
    func respond(to request: Request, chainingTo next: Responder) throws -> EventLoopFuture<Response> {
        
        return try next.respond(to: request).map { response in
            
            //Temporarily set all to 10 minutes TTL

            response.http.headers.add(name: .cacheControl, value: "public, max-age=600")
            response.http.headers.add(name: .vary, value: "Accept-Encoding")
            return response
        }
    }
}
