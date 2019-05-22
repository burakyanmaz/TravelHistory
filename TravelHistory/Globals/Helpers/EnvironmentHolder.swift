//
//  EnvironmentManager.swift
//  TravelHistory
//
//  Created by Burak Yanmaz on 22.05.2019.
//  Copyright © 2019 Simpler. All rights reserved.
//

import UIKit

struct EnvironmentHolder {
    static var credentials: (appID: String, appCode: String) {
        return (appID: ConnectionHelper.Environment.cit.appID, appCode: ConnectionHelper.Environment.cit.appCode)
    }
}
