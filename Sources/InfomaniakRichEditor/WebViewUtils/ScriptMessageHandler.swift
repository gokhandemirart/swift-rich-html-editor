//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing,
//  software distributed under the License is distributed on an
//  "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
//  KIND, either express or implied.  See the License for the
//  specific language governing permissions and limitations
//  under the License.


import OSLog
import WebKit

protocol ScriptMessageHandlerDelegate: AnyObject {
    func userDidType(_ text: String)
    func selectionDidChange(_ selectedTextAttributes: RETextAttributes?)
}

final class ScriptMessageHandler: NSObject, WKScriptMessageHandler {
    enum Handler: String, CaseIterable {
        case userDidType
        case selectionDidChange
        case scriptLog
    }

    weak var delegate: ScriptMessageHandlerDelegate?

    private let logger = Logger(subsystem: "com.infomaniak.swift-rich-editor", category: "ScriptMessageHandler")

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard let messageName = Handler(rawValue: message.name) else {
            return
        }

        switch messageName {
        case .userDidType:
            userDidType(message)
        case .selectionDidChange:
            selectionDidChange(message)
        case .scriptLog:
            scriptLog(message)
        }
    }

    private func userDidType(_ message: WKScriptMessage) {
        guard let body = message.body as? String else {
            return
        }
        delegate?.userDidType(body)
    }

    private func selectionDidChange(_ message: WKScriptMessage) {
        guard let body = message.body as? String, let data = body.data(using: .utf8) else {
            return
        }

        do {
            let decoder = JSONDecoder()
            let selectedTextAttributes = try decoder.decode(RETextAttributes.self, from: data)

            delegate?.selectionDidChange(selectedTextAttributes)
        } catch {
            logger.error("Error while trying to decode RETextAttributes: \(error)")
            delegate?.selectionDidChange(nil)
        }
    }

    private func scriptLog(_ message: WKScriptMessage) {
        guard let body = message.body as? String else {
            return
        }
        logger.info("[ScriptLog] \(body)")
    }
}