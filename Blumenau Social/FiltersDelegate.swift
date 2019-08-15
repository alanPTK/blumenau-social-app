//
//  FiltersDelegate.swift
//  Blumenau Social
//
//  Created by Alan Filipe Cardozo Fabeni on 14/08/19.
//  Copyright © 2019 Alan Filipe Cardozo Fabeni. All rights reserved.
//

import UIKit

protocol FiltersDelegate {
    
    func showLoadingMessage(message: String)
    func hideLoadingMessage()
    func showErrorMessage(message: String)

}
