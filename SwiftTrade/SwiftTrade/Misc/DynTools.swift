//
//  DynTools.swift
//  SwiftTrade
//
//  Created by Petr Homola on 05/12/2025.
//

import Foundation
import NaturalLanguage

final class ToolInfo {
    let name: String
    let description: String
    
    init(name: String, description: String) {
        self.name = name
        self.description = description
    }
}

final class ToolManager {
    let embedding: NLEmbedding
    var tools: [ToolInfo]
    
    init?(tools: [ToolInfo] = []) {
        if let embedding = NLEmbedding.sentenceEmbedding(for: .english) {
            self.embedding = embedding
            self.tools = tools
        } else {
            return nil
        }
    }
    
    func addTool(name: String, description: String) {
        let toolInfo = ToolInfo(name: name, description: description)
        tools.append(toolInfo)
    }
    
    func pickTool(query: String) -> ToolInfo {
        var minimumDistance = Double.greatestFiniteMagnitude
        var toolInfo: ToolInfo?
        for tool in tools {
            let distance = embedding.distance(between: query, and: tool.description, distanceType: .cosine)
            if distance < minimumDistance {
                minimumDistance = distance
                toolInfo = tool
            }
        }
        print("distance for '\(query)': \(minimumDistance)")
        return toolInfo!
    }
}

func dyntoolsExper() {
    guard let toolManager = ToolManager() else { print("failed to get tool manager"); return }
    toolManager.addTool(name: "weather", description: """
        Fetches weather forecasts.
        Arguments:
        Latitude - the latitude of the location
        Longitude - the longitude of the location
        """)
    toolManager.addTool(name: "stocks", description: """
        Fetches stock prices at a day in the past.
        Arguments:
        Symbol - the symbol of the stock
        Date - the date
        """)
    toolManager.addTool(name: "capitals", description: """
        Provides capitals for the world's countries.
        Arguments:
        Country - the country's name
        """)
    let tool1 = toolManager.pickTool(query: "What is the weather forecast for Dublin?")
    print(tool1.name)
    let tool2 = toolManager.pickTool(query: "What will the weather be like in Dublin?")
    print(tool2.name)
    let tool3 = toolManager.pickTool(query: "Give me the stock price for Apple on September 15, 2024.")
    print(tool3.name)
    let tool4 = toolManager.pickTool(query: "Give me yesterday's stock price for Apple.")
    print(tool4.name)
    let tool5 = toolManager.pickTool(query: "What is the capital of Italy?")
    print(tool5.name)
    let tool6 = toolManager.pickTool(query: "How many people live in Japan?")
    print(tool6.name)
}
