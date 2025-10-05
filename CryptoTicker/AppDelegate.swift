
//
//  AppDelegate.swift
//  CryptoTicker
//
//  Created on 2024
//  Copyright © 2024 CryptoTicker. All rights reserved.
//

import SwiftUI

/// AppDelegate handles the menu bar functionality and popover presentation
class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem?
    var popover: NSPopover?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Create status bar item
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        if let button = statusItem?.button {
            button.image = NSImage(systemSymbolName: "bitcoinsign.circle", accessibilityDescription: "CryptoTicker")
            button.action = #selector(togglePopover)
        }

        // Configure popover
        self.popover = NSPopover()
        self.popover?.contentSize = NSSize(width: 350, height: 450)
        self.popover?.behavior = .transient
        self.popover?.contentViewController = NSHostingController(rootView: ContentView())
    }

    @objc func togglePopover() {
        if let button = statusItem?.button {
            if popover?.isShown == true {
                popover?.performClose(nil)
            } else {
                popover?.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
            }
        }
    }
}
