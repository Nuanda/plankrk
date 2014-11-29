module ApplicationHelper

  def body_data_dispatch
    [controller.controller_name, controller.action_name].compact.join(':')
  end

end
