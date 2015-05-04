module SpreadBeaver
  class Runner
    QUEUE_KEY = :_spread_beaver_queue

    cattr_accessor :pool

    def self.setup! bundle, opts={size: 10, timeout: 20}
      @@bundle = bundle
      @@pool.shutdown{} if @@pool
      @@pool = ConnectionPool.new(opts) { self.new }
    end

    def self.exec module_name, props
      @@pool.with do |r|
        r.exec module_name, props
      end
    end

    def self.queue module_name, props
      if RequestStore.store[QUEUE_KEY].nil?
        RequestStore.store[QUEUE_KEY] = []
      end
      RequestStore.store[QUEUE_KEY].push module_name: module_name, props: props
    end

    def exec module_name, props
      js_code = "(function() {"
      js_code += initialize_script if !initialize_script.nil?
      if !RequestStore.store[self.class::QUEUE_KEY].nil?
        RequestStore.store[self.class::QUEUE_KEY].each do |store|
          str = exec_queued_module store[:module_name], store[:props]
          js_code += str if !str.nil?
        end
      end
      js_code += "return #{exec_module module_name, props}"
      js_code += "})()"
      context.eval(js_code).html_safe
    end

    private

    def context
      @context ||= ExecJS.compile <<-JS
        var global = {};
        #{@@bundle}
      JS
    end

    def initialize_script
      #Override this.
      nil
    end

    def exec_queued_module module_name, props
      #Override this.
      nil
    end

    def exec_module module_name, props
      raise "Override this."
    end

    def props_to_s props
      if props.is_a? String
        props
      else
        props.to_json
      end
    end
  end
end
