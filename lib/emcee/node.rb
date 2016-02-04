module Emcee
  # Document is responsible for interacting with individual html nodes that
  # make up the parsed document.
  class Node
    def initialize(parser_node)
      @parser_node = parser_node
    end

    def path
      href || src
    end

    def remove
      @parser_node.remove
    end

    def replace(type, new_content)
      new_node = Nokogiri::XML::Node.new(type, document)
      new_node.content = new_content
      new_node.set_attribute(shim, "") if shim
      @parser_node.replace(new_node)
    end

    private

    def href
      @parser_node.attribute("href").try(:value)
    end

    def src
      @parser_node.attribute("src").try(:value)
    end

    def shim
      @parser_node.attribute("no-shim").try!(:name) || @parser_node.attribute("shim-shadowdom").try!(:name)
    end

    def document
      @parser_node.document
    end
  end
end
