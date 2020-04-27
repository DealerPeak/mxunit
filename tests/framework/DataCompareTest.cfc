<cfcomponent extends="mxunit.framework.TestCase">

	<cffunction name="testCompareStructs">
		<cfscript>
			var tests = [
				{
					name: "Empty Structs Match",
					args: {
						struct1: {},
						struct2: {}
					},
					expect: {
						message: "",
						success: true,
						UniqueToStruct1: "",
						UniqueToStruct2: "",
						mismatches: {},
						Struct1MismatchValues: "",
						Struct2MismatchValues: ""
					}
				},
				{
					name: "Null Values (same keys match)",
					args: {
						struct1: {
							a: "a",
							b: JavaCast("null", "")
						},
						struct2: {
							a: "a",
							b: JavaCast("null", "")
						}
					},
					expect: {
						message: "",
						success: true,
						UniqueToStruct1: "",
						UniqueToStruct2: "",
						mismatches: {},
						Struct1MismatchValues: "",
						Struct2MismatchValues: ""
					}
				},
				{
					name: "Null Values (1 null, 2 value)",
					args: {
						struct1: {
							a: "a",
							b: JavaCast("null", "")
						},
						struct2: {
							a: "a",
							b: "b"
						}
					},
					expect: {
						message: "",
						success: false,
						UniqueToStruct1: "",
						UniqueToStruct2: "",
						mismatches: {
							'[ "B" ]': {
								Struct1Value: "UNDEFINED",
								Struct2Value: "b"
							}
						},
						Struct1MismatchValues: 'Structure path [ "B" ]: UNDEFINED',
						Struct2MismatchValues: 'Structure path [ "B" ]: b'
					}
				},
				{
					name: "Keys of different types",
					args: {
						struct1: {
							a: "a",
							b: {"key": "n/a"}
						},
						struct2: {
							a: "a",
							b: "b"
						}
					},
					expect: {
						message: 'Not sure how to compare these datatypes at path [ "B" ]. File a bug with a patch. ',
						success: false,
						UniqueToStruct1: "",
						UniqueToStruct2: "",
						mismatches: {},
						Struct1MismatchValues: 'Structure path [ "B" ]: CANNOT COMPARE',
						Struct2MismatchValues: 'Structure path [ "B" ]: CANNOT COMPARE'
					}
				}
			];
			var dc = new mxunit.framework.DataCompare();
			for (var test in tests) {
				try {
					var actual = dc.compareStructs(argumentCollection = test.args);
					// debug(actual);
					AssertEquals(test.expect, actual, test.name);
				} catch (any e) {
					debug(e);
					fail("#test.name#: unexpected exception. run w/ debug for details.");
				}
			}
		</cfscript>
	</cffunction>

</cfcomponent>