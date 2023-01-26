//
//  Extensions.swift
//  CollegeCGPAios
//
//  Created by dremobaba on 2023/1/26.
//

import Foundation

extension Array where Element == Float  {
    func sum() ->Float {
        return self.reduce(0, {$0 + $1})
    }
}
