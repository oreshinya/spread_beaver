module SpreadBeaver
  class Runner
    def initialize_script
      "global.context.clearAllStores();"
    end

    def exec_queued_module module_name, props
      "global.context.initStore('#{module_name}', #{props_to_s(props)});"
    end

    def exec_module module_name, props
      "global.context.renderComponent('#{module_name}', #{props_to_s(props)});"
    end
  end
end
