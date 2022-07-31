# frozen_string_literal: true
require "hanami/utils"

module Hanami
  module Extensions
    module StringUtil
      refine String do
        def underscore()
          Hanami::Utils::String.underscore(self)
        end

        def camelize()
          Hanami::Utils::String.classify(self)
        end

        def modulize()
          split(/[#\/]/).map(&:camelize).join("::")
        end

        def class_name()
          Hanami::Utils::String.demodulize(self)
        end

        def module_name()
          return "" if self !~ /::/
          gsub(/::[^:]+$/, "")
        end

        def modules()
          names = split("::")
          names.first(names.size - 1)
        end
      end
    end
  end
end