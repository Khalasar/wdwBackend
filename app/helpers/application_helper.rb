module ApplicationHelper
  def controller?(*controller)
    controller.include?(params[:controller])
  end

  def action?(*action)
    action.include?(params[:action])
  end

  def active?(controller, action)
    'active' if controller?(controller) && action?(action)
  end
end
