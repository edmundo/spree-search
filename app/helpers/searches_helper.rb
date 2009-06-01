module SearchesHelper

  # Redefined here to not escape html characters inside the select options, we need to add &nbsp; tags
  # there to change indentation of subitems.
#  def options_for_select(container, selected = nil)
#    container = container.to_a if Hash === container
#
#    options_for_select = container.inject([]) do |options, element|
#      text, value = option_text_and_value(element)
#      selected_attribute = ' selected="selected"' if option_value_selected?(value, selected)
#      options << %(<option value="#{html_escape(value.to_s)}"#{selected_attribute}>#{text.to_s}</option>)
#    end
#
#    options_for_select.join("\n")
#  end

  # Redefined here to not escape html characters inside the select options, we need to add &nbsp; tags
  # there to change indentation of subitems. Changed version to fit option_tags_with_disable plugin.
  def options_for_select(container, selected = nil, disabled = nil)
    container = container.to_a if Hash === container

    options_for_select = container.inject([]) do |options, element|
      text, value = option_text_and_value(element)
      selected_attribute = ' selected="selected"' if option_value_selected?(value, selected)
      disabled_attribute = ' disabled="disabled"' if option_value_selected?(value, disabled) && disabled != nil
      options << %(<option value="#{html_escape(value.to_s)}"#{selected_attribute}#{disabled_attribute}>#{text.to_s}</option>)
    end

    options_for_select.join("\n")
  end


end
