module Gensim
  module Models
    @models = PyCall.import_module("gensim.models")
    PyCall.dir(@models).each do |name|
      obj = PyCall.getattr(@models, name)
      next unless obj.kind_of?(PyCall::PyObject) || obj.kind_of?(PyCall::PyObjectWrapper)
      next unless PyCall.callable?(obj)

      define_singleton_method(name) do |*args, **kwargs|
        obj.(*args, **kwargs)
      end
    end

    class << self
      def __pyobj__
        @models
      end

      def method_missing(name, *args, **kwargs)
        return super unless PyCall.hasattr?(@models, name)
        PyCall.getattr(@models, name)
      end
    end
  end
end

require "gensim/models/word2vec"
