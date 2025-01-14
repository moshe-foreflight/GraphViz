import Foundation
import Dispatch

extension Graph {
    /**
     Renders the graph using the specified layout algorithm to the desired output format.

     - Parameters:
        - layout: The layout algorithm.
        - format: The output format.
        - options: The rendering options.
     - Throws: `CocoaError` if the corresponding GraphViz tool isn't available.
     */
    public func render(using layout: LayoutAlgorithm,
                       to format: Format,
                       with options: Renderer.Options = [],
                       on queue: DispatchQueue = .main,
                       completion: (@escaping (Result<Data, Swift.Error>) -> Void))
    {
        Renderer(layout: layout, options: options).render(graph: self, to: format, completion: completion)
    }
    
    /**
     Calls

     - Parameters:
        - layout: The layout algorithm.
        - format: The output format.
        - options: The rendering options.
     - Throws: `CocoaError` if the corresponding GraphViz tool isn't available.
     */
    @available(macOS 10.15, *)
    public func render(using layout: LayoutAlgorithm,
                       to format: Format,
                       with options: Renderer.Options = [],
                       on queue: DispatchQueue = .main) async throws -> Data {
        return try await withCheckedThrowingContinuation { continuation in
            render(using: layout, to: format, with: options, on: queue) { result in
                continuation.resume(with: result)
            }
        }
    }
}
