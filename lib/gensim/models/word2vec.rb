module Gensim
  module Models
    module Word2Vec
      @word2vec = PyCall.import_module("gensim.models.word2vec")
      PyCall.dir(@word2vec).each do |name|
        obj = PyCall.getattr(@word2vec, name)
        next unless obj.kind_of?(PyCall::PyObject) || obj.kind_of?(PyCall::PyObjectWrapper)
        next unless PyCall.callable?(obj)

        define_singleton_method(name) do |*args, **kwargs|
          obj.(*args, **kwargs)
        end
      end

      class << self
        def __pyobj__
          @word2vec
        end

        def method_missing(name, *args, **kwargs)
          return super unless PyCall.hasattr?(@word2vec, name)
          PyCall.getattr(@word2vec, name)
        end
      end

      class BrownCorpus
        include PyCall::PyObjectWrapper
        wrap_class PyCall.import_module("gensim.models.word2vec").BrownCorpus
      end

      class LineSentence
        include PyCall::PyObjectWrapper
        wrap_class PyCall.import_module("gensim.models.word2vec").LineSentence
      end

      class Text8Corpus
        include PyCall::PyObjectWrapper
        wrap_class PyCall.import_module("gensim.models.word2vec").Text8Corpus
      end

      class Word2Vec
        include PyCall::PyObjectWrapper
        wrap_class PyCall.import_module("gensim.models.word2vec").Word2Vec
      end
    end
  end
end
