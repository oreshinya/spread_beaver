require 'spec_helper'

describe SpreadBeaver do
  before :all do
    @bundle = <<-JS
      var testStore = {
        _store: {},
        clear: function() {
          this._store = {};
        },
        init: function(data) {
          var i=0;
          for (;i<data.length;i++) {
            this._store[data[i].id] = data[i];
          }
        },
        ids: function() {
          var key;
          var result = [];
          for (key in this._store) {
            result.push(this._store[key].id);
          }
          return result;
        }
      };

      var stores = [testStore];

      var clearAllStores = function() {
        var i=0;
        for (;i<stores.length;i++) {
          stores[i].clear();
        }
      };

      var view = {
        render: function(props) {
          return "ids: "+testStore.ids().join()+", props: "+JSON.stringify(props);
        }
      };
    JS

    module SpreadBeaver
      class Runner
        private
        def initialize_script
          "clearAllStores();"
        end

        def exec_queued_module module_name, props
          "#{module_name}.init(#{props_to_s(props)});"
        end

        def exec_module module_name, props
          "#{module_name}.render(#{props_to_s(props)});"
        end
      end
    end

    SpreadBeaver::Runner.setup! @bundle
  end

  it 'has a version number' do
    expect(SpreadBeaver::VERSION).not_to be nil
  end

  describe SpreadBeaver::Runner do
    describe ".setup!" do
      it "has javascript bundle" do
        expect(SpreadBeaver::Runner.class_eval("@@bundle")).to be(@bundle)
      end

      it "has execution pool" do
        expect(SpreadBeaver::Runner.pool.class).to be(ConnectionPool)
      end
    end

    describe ".queue" do
      before do
        SpreadBeaver::Runner.queue "testStore", [{id: 1}, {id: 2}]
        @store = RequestStore.store[SpreadBeaver::Runner::QUEUE_KEY][0]
      end
      it "stores data to request store" do
        expect(@store[:module_name]).to eql("testStore")
        expect(@store[:props]).to eql([{id: 1}, {id: 2}])
      end
    end

    describe ".exec" do
      before do
        SpreadBeaver::Runner.queue "testStore", [{id: 1}, {id: 2}]
      end
      it "return execution result string" do
        expect(SpreadBeaver::Runner.exec("view", {hoge: :fuga})).to eql("ids: 1,2, props: {\"hoge\":\"fuga\"}")
      end
    end
  end
end
