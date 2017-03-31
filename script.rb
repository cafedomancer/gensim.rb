require "gensim"

Text8Corpus = PyCall.import_module("gensim.models.word2vec").Text8Corpus
Word2Vec = PyCall.import_module("gensim.models.word2vec").Word2Vec

p sentences = Text8Corpus.("text8")
p model = Word2Vec.(sentences, size: 100, window: 5, min_count: 5, workers: 4)

p model.wv["computers"]
p model.wv.most_similar.(positive: ["woman", "king"], negative: ["man"])
