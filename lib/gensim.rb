require "pycall"

module Gensim
  @gensim = PyCall.import_module("gensim")
  PyCall.dir(@gensim).each do |name|
    obj = PyCall.getattr(@gensim, name)
    next unless obj.kind_of?(PyCall::PyObject) || obj.kind_of?(PyCall::PyObjectWrapper)
    next unless PyCall.callable?(obj)

    define_singleton_method(name) do |*args, **kwargs|
      obj.(*args, **kwargs)
    end
  end

  class << self
    def __pyobj__
      @gensim
    end

    def method_missing(name, *args, **kwargs)
      return super unless PyCall.hasattr?(@gensim, name)
      PyCall.getattr(@gensim, name)
    end
  end
end

require "gensim/models"
require "gensim/version"
