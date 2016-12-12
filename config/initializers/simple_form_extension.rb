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
