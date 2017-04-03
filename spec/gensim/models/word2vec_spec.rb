require "spec_helper"

RSpec::Matchers.define :models_equal do |expected|
  match do |actual|
    np = PyCall.import_module("numpy")

    expect(PyCall.len(actual.wv.syn0)).to eq(PyCall.len(expected.wv.syn0)) # self.assertEqual(len(model.wv.vocab), len(model2.wv.vocab))
    expect(np.allclose.(expected.wv.syn0, actual.wv.syn0)).to be true # self.assertTrue(np.allclose(model.wv.syn0, model2.wv.syn0))
    expect(np.allclose.(expected.syn1, actual.syn1)).to be true if expected.hs.nonzero? # if model.hs self.assertTrue(np.allclose(model.syn1, model2.syn1))
    expect(np.allclose.(expected.syn1neg, actual.syn1neg)).to be true if expected.negative.nonzero? # if model.negative self.assertTrue(np.allclose(model.syn1neg, model2.syn1neg))
    most_common_word = expected.wv.vocab.keys.zip(expected.wv.vocab.values).max { |item| item[1].count }[0] # most_common_word = max(model.wv.vocab.items(), key=lambda item: item[1].count)[0]
    expect(np.allclose.(expected[most_common_word], actual[most_common_word])).to be true # self.assertTrue(np.allclose(model[most_common_word], model2[most_common_word]))
  end
end

RSpec.describe Gensim::Models::Word2Vec do
  let(:sentences) {
    [
      ["human", "interface", "computer"],
      ["survey", "user", "computer", "system", "response", "time"],
      ["eps", "user", "interface", "system"],
      ["system", "human", "system", "eps"],
      ["user", "response", "time"],
      ["trees"],
      ["graph", "trees"],
      ["graph", "minors", "trees"],
      ["graph", "minors", "survey"]
    ]
  }

  describe "TestWord2VecModel" do
    it "tests word2vec training" do
      # build vocabulary, don't train yet
      model = PyCall.import_module("gensim.models.word2vec").Word2Vec.(size: 2, min_count: 1, hs: 1, negative: 0) # model = word2vec.Word2Vec(size=2, min_count=1, hs=1, negative=0)
      model.build_vocab(sentences)

      expect(model.wv.syn0.shape).to eq(PyCall.tuple(PyCall.len(model.wv.vocab), 2)) # self.assertTrue(model.wv.syn0.shape == (len(model.wv.vocab), 2))
      expect(model.syn1.shape).to eq(PyCall.tuple(PyCall.len(model.wv.vocab), 2)) # self.assertTrue(model.syn1.shape == (len(model.wv.vocab), 2))

      model.train(sentences) # model.train(sentences)
      sims = model.most_similar('graph', topn: 10) # sims = model.most_similar('graph', topn=10)
      # self.assertTrue(sims[0][0] == 'trees', sims)  # most similar

      # test querying for "most similar" by vector
      graph_vector = model.wv.syn0norm[model.wv.vocab['graph'].index]
      sims2 = model.most_similar(positive: [graph_vector], topn: 11) # sims2 = model.most_similar(positive=[graph_vector], topn=11)
      sims2 = sims2.select { |w, sim| w != "graph" } # sims2 = [(w, sim) for w, sim in sims2 if w != 'graph']  # ignore 'graph' itself
      expect(sims).to eq(sims2) # self.assertEqual(sims, sims2)

      # build vocab and train in one step; must be the same as above
      model2 = PyCall.import_module("gensim.models.word2vec").Word2Vec.(sentences, size: 2, min_count: 1, hs: 1, negative: 0) # model2 = word2vec.Word2Vec(sentences, size=2, min_count=1, hs=1, negative=0)
      expect(model2).to models_equal(model) # self.models_equal(model, model2)
    end
  end
end
