class ValidationServerErrorHandler
	constructor: (@model, @response) ->

	addErrorMessage: (key, message) ->
		@model.get("validationErrors").add(key, "serverError", null, message)

	clear: ->
		@model.get("validationErrors").clear()

	getServerExtraKeyMapping: (key) ->
		switch key
			when "incorporation_date" then "business.incorporation_date"
			when "tax_id" then "business.tax_id"
			when "dob" then "person.dob"
			else key

	execute: ->
		errorsList = @response.errors || []

		_.each errorsList, (error) =>
			if _.keys(error.extras).length > 0
				_.each error.extras, (message, key) =>
					key = @getServerExtraKeyMapping(key)
					@addErrorMessage(key, message)
			else if error.description
				if error.description.indexOf(" - ") > 0
					message = error.description.split(" - ")[1]
				else
					message = error.description
				@addErrorMessage("", message)
			else
				@addErrorMessage("", error[0])

`export default ValidationServerErrorHandler`
