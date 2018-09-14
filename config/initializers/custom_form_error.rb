ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
  if html_tag =~ /<label/
    html_field = Nokogiri::HTML::DocumentFragment.parse(html_tag)
    html_field.children.add_class 'error'
    html_field.to_s.html_safe
  else
    html_field = Nokogiri::HTML::DocumentFragment.parse(html_tag)
    html_field.children.add_class 'error'
    span_elem = %(
      <i aria-hidden="true" 
      class="error notification-popover fas fa-exclamation-circle"
      data-container="body" 
      data-toggle="popover"
      data-placement="left"
      data-html="false"
      data-content="It #{instance.error_message.first}"
      data-trigger="click"></i>
      ).squish() 
    html_field.children.after(span_elem)
    html_field.to_s.html_safe
  end
end
