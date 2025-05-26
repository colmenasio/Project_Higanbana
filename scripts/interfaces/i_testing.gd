class_name ITesting

const _methods = ["i_test"]


# Returns true if the object implements this interface
static func impl(object) -> bool:
	return ITesting._methods.all(object.has_method)
