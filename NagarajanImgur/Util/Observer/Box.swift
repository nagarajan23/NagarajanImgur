//
//  Box.swift
//  NagarajanImgur
//
//  Created by Nagarajan S D on 19/04/20.
//  Copyright © 2020 Nagarajan. All rights reserved.
//

import Foundation

class Box<T> {
    typealias Listener = (T) -> Void
    var listeners:[Listener] = [Listener]()
    var value: T {
        didSet {
            for listener in listeners {
                listener(value)
            }
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(listener: Listener?) {
        if let newListener = listener {
            self.listeners.append(newListener)
            newListener(value)
        }
    }
}
