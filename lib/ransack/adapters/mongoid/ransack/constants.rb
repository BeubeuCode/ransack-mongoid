module Ransack
  module Constants
    module_function

    # Override escape_wildcards to not depend on ActiveRecord. MongoDB uses
    # regex matching so we escape regex special chars instead of SQL wildcards.
    def escape_wildcards(unescaped)
      Regexp.escape(unescaped.to_s)
    end

    def escape_regex(unescaped)
      Regexp.escape(unescaped.to_s)
    end
  end
end
