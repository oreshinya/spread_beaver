module SpreadBeaver
  class Runner
    def initialize_script
      "global.clearAllStores();"
    end

    def exec_queued_module module_name, props
      "global.initStore('#{module_name}', #{props_to_s(props)});"
    end

    def exec_module module_name, props
      "global.renderComponent('#{module_name}', #{props_to_s(props)});"
    end
  end
end
