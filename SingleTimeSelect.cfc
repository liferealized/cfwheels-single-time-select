<cfcomponent>

	<cffunction name="init" access="public">
		<cfscript>
			var loc = {};
		
			this.version = "1.0,1.1";
			
			loc.defaults = {label="", labelPlacement="around", prepend="", append="", prependToLabel="", appendToLabel="", errorElement="span", includeBlank=false, order="hourMinute", separator=":", minuteStep=30};
		
			if (not StructKeyExists(application.wheels.functions, "singleTimeSelect"))
				application.wheels.functions.singleTimeSelect = {};
			
			for (loc.item in loc.defaults)
				if (not StructKeyExists(application.wheels.functions.singleTimeSelect, loc.item))
					application.wheels.functions.singleTimeSelect[loc.item] = loc.defaults[loc.item];
		</cfscript>
		<cfreturn this />
	</cffunction>

	<cffunction name="singleTimeSelect" returntype="string" access="public" output="false" hint="Builds and returns a string containing a single select form control for a time based on the supplied `objectName` and `property`.">
		<cfargument name="objectName" type="any" required="false" default="" />
		<cfargument name="property" type="string" required="false" default="" />
		<cfargument name="order" type="string" required="false" default="#application.wheels.functions.singleTimeSelect.order#" />
		<cfargument name="separator" type="string" required="false" default="#application.wheels.functions.singleTimeSelect.separator#" />
		<cfargument name="minuteStep" type="numeric" required="false" default="#application.wheels.functions.singleTimeSelect.minuteStep#" />
		<cfargument name="includeBlank" type="any" required="false" default="#application.wheels.functions.timeSelect.includeBlank#" />
		<cfargument name="label" type="string" required="false" default="#application.wheels.functions.singleTimeSelect.label#" />
		<cfargument name="labelPlacement" type="string" required="false" default="#application.wheels.functions.singleTimeSelect.labelPlacement#" />
		<cfargument name="prepend" type="string" required="false" default="#application.wheels.functions.singleTimeSelect.prepend#" />
		<cfargument name="append" type="string" required="false" default="#application.wheels.functions.singleTimeSelect.append#" />
		<cfargument name="prependToLabel" type="string" required="false" default="#application.wheels.functions.singleTimeSelect.prependToLabel#" />
		<cfargument name="appendToLabel" type="string" required="false" default="#application.wheels.functions.singleTimeSelect.appendToLabel#" />
		<cfargument name="errorElement" type="string" required="false" default="#application.wheels.functions.singleTimeSelect.errorElement#" />
		<cfscript>
			arguments = $insertDefaults(name="timeSelect", input=arguments);
			arguments.$functionName = "timeSelect";
		</cfscript>
		<cfreturn $dateOrTimeSelect(argumentCollection=arguments)>
	</cffunction>

	<cffunction name="$hourMinuteSelectTag" returntype="string" access="public" output="false">
		<cfargument name="$optionNames" type="string" required="false" default="">
		<cfscript>
			var loc = {};
			
			arguments.$loopFromHour = 0;
			arguments.$loopToHour = 23;
			arguments.$hourStep = 1;
			
			arguments.$loopFromMinute = 0;
			arguments.$loopToMinute = 59;
			arguments.$minuteStep = arguments.minuteStep;
			
			loc.before = $formBeforeElement(argumentCollection=arguments);
			loc.after = $formAfterElement(argumentCollection=arguments);
			
			arguments.name = $tagName(arguments.objectName, arguments.property);
			
			loc.content = "";
			if (!IsBoolean(arguments.includeBlank) || arguments.includeBlank)
			{
				loc.args = {};
				loc.args.value = "";
				if (!IsBoolean(arguments.includeBlank))
					loc.optionContent = arguments.includeBlank;
				else
					loc.optionContent = "";
				loc.content = loc.content & $element(name="option", content=loc.optionContent, attributes=loc.args);
			}
			for (loc.i=arguments.$loopFromHour; loc.i <= arguments.$loopToHour; loc.i=loc.i+arguments.$hourStep)
			{
				for (loc.j=arguments.$loopFromMinute; loc.j lte arguments.$loopToMinute; loc.j=loc.j + arguments.$minuteStep)
				{
					loc.args = {};
					loc.args.value = NumberFormat(loc.i, "09") & ":" & NumberFormat(loc.j, "09") & ":" & NumberFormat(0, "09");
					if (arguments.value == loc.i)
						loc.args.selected = "selected";
					loc.meridiem = IIf((loc.i + 1) gt 12, "'pm'", "'am'");
					loc.hourContent = 12;
					if (loc.i gt 12)
						loc.hourContent = NumberFormat(loc.i - 12, "09");
					else if (loc.i neq 0)
						loc.hourContent = NumberFormat(loc.i, "09");
					loc.minuteContent = NumberFormat(loc.j, "09");	
					loc.optionContent = loc.hourContent & arguments.separator & loc.minuteContent & " " & loc.meridiem;
					loc.content = loc.content & $element(name="option", content=loc.optionContent, attributes=loc.args);
					if (!StructKeyExists(arguments, "id"))
						arguments.id = arguments.$id;
				}
			}
			loc.returnValue = loc.before & $element(name="select", skip="objectName,property,label,labelPlacement,prepend,append,prependToLabel,appendToLabel,errorElement,value,includeBlank,order,separator,startYear,endYear,monthDisplay,dateSeparator,dateOrder,timeSeparator,timeOrder,minuteStep", skipStartingWith="label", content=loc.content, attributes=arguments) & loc.after;
		</cfscript>
		<cfreturn loc.returnValue>
	</cffunction>	

</cfcomponent>