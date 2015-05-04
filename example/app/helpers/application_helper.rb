module ApplicationHelper
  def react_component module_path, props=nil, opts={}
    data = {"react-component": module_path}
    data["react-props"] = props if props.present?
    block = Proc.new {concat SpreadBeaver::Runner.exec(module_path, props)} if opts[:prerender]
    content_tag :div, nil, data: data, &block
  end

  def flux_store_initializer module_path, props=nil, opts={}
    data = {"store": module_path}
    data["store-props"] = props if props.present?
    SpreadBeaver::Runner.queue module_path, props if opts[:prerender]
    content_tag :div, nil, style: {display: :none}, data: data
  end
end
