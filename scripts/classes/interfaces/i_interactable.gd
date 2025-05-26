class_name IInteractable

const _methods = ["i_interact"];

# Returns true if the object implements this interface
static func impl(object) -> bool:
	return IInteractable._methods.all(object.has_method)
