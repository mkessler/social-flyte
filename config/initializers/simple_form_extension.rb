# SimpleForm::Components::Labels.module_eval do
#   def label(wrapper_options = nil)
#     label_options = merge_wrapper_options(label_html_options, wrapper_options)
#     label_options['data-error'] = object.errors.messages[attribute_name] if has_errors?
#
#     if generate_label_for_attribute?
#       @builder.label(label_target, label_text, label_options)
#     else
#       template.label_tag(nil, label_text, label_options)
#     end
#   end
#
#   def label_html_options
#     label_html_classes = SimpleForm.additional_classes_for(:label) {
#       [input_type, required_class, disabled_class, SimpleForm.label_class].compact
#     }
#
#     label_html_classes.push('active') if has_errors?
#
#     label_options = html_options_for(:label, label_html_classes)
#     if options.key?(:input_html) && options[:input_html].key?(:id)
#       label_options[:for] = options[:input_html][:id]
#     end
#
#     label_options
#   end
# end

SimpleForm::Helpers::Required.module_eval do
  def required_class
    required_field? ? 'required validate' : :optional
  end
end

SimpleForm::Inputs::Base.module_eval do
  def additional_classes
    error_class = has_errors? ? 'invalid' : ''
    @additional_classes ||= [input_type, required_class, readonly_class, disabled_class, error_class].compact
  end
end
