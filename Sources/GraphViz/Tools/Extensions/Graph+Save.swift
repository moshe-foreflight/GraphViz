//
//  Graph+Save.swift
//  
//
//  Created by Moshe Berman on 10/13/23.
//

import Foundation

@available(macOS 13.0, *)
extension GraphViz.Graph {
    /// Renders a given graph to a file using and saves it as `basename.format`.
    ///
    /// - Parameters:
    ///   - graph: The graph to save.
    ///   - basename: The name of the file.
    ///   - format: The file format to use. This depends on what GraphViz components exist on the local system.
    ///   - algorithm: The layout algorithm to use for drawing the graph.
    ///         - `twopi` is the default because its output is clear-er than `dot` and faster than `circo`.
    ///         - For small graphs, `circo` has a pretty layout.
    ///         - For a speedy alternative to `twopi`, try `sfdp`.
    ///   - folder: Where to save the file.
    public func save(
        basename:String,
        format: GraphViz.Format = .pdf,
        algorithm: GraphViz.LayoutAlgorithm = .twopi,
        folder: URL = FileManager.default.homeDirectoryForCurrentUser
    ) async {
        var g = self
        g.overlap = "false"
        print("Rendering", terminator: "... ")
        let dot:Data
        do {
            dot = try await g.render(using: algorithm, to: format)
        } catch let e {
            print("Failed!")
            print("🚨 Failed to get graph data.")
            print("🚨 \(e.localizedDescription)")
            let graphString = DOTEncoder().encode(g)
            print("🚨 \(graphString)")
            return
        }
        print("Done!")
        let outputURL = folder.appending(
            path: "Desktop/\(basename).pdf"
        ).standardizedFileURL
        do {
            print("Writing Data", terminator: " ... ")
            try dot.write(to: outputURL)
            print("Saved to \(outputURL.path)", terminator: "... ")
        }
        catch let e {
            print("Failed!")
            print("🚨 Failed to save SVG to \(outputURL).")
            print("🚨 Error: \(e)")
        }
    }
}
