module Emcee
  module Processors
    # StylesheetProcessor scans a document for external stylesheet references and
    # inlines them into the current document.
    class StylesheetProcessor
      def initialize(resolver)
        @resolver = resolver
      end

      def process(doc)
        inline_styles(doc)
        doc
      end

      private

      def inline_styles(doc)
        doc.style_references.each do |node|
          next unless @resolver.should_inline?(node.path)
          path = @resolver.absolute_path(node.path)
          content = @resolver.evaluate(path)
          node.replace("style", content)
          @resolver.depend_on_asset(path)
        end
      end
    end
  end
end
