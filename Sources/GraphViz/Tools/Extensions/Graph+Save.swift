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
    ///
    ///
    /// - Returns: The path to the file.
    public func save(
        basename:String,
        format: GraphViz.Format = .pdf,
        algorithm: GraphViz.LayoutAlgorithm = .twopi,
        folder: URL = FileManager.default.homeDirectoryForCurrentUser,
        options: Renderer.Options = []
    ) async throws -> String {
        var g = self
        g.overlap = "false"
        let data:Data
        let fileExtension = format.rawValue
        
#if canImport(Clibgraphviz)
        if format == .dot {
            /// If `graphviz` isn't installed, we'll generate a text file in the dot format.
            let graphString = DOTEncoder().encode(g)
            data = graphString.data(using: .utf8)!
        } else {
            data = try await g.render(using: algorithm, to: format, with:options)
        }
#else
        /// If `graphviz` isn't installed, we'll generate a text file in the dot format.
        let fileExtension = "txt"
        let graphString = DOTEncoder().encode(g)
        data = graphString.data(using: .utf8)!
#endif
        let outputURL = folder.appending(
            path: "Desktop/\(basename).\(fileExtension)"
        ).standardizedFileURL
        try data.write(to: outputURL)
        return outputURL.standardizedFileURL.absoluteString
    }
}
