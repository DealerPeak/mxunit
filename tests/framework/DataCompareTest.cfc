<cfcomponent extends="mxunit.framework.TestCase">

	<cffunction name="testCompareArrays">
		<cfscript>
			var tests = [
				{
					name: "Empty Arrays Match",
					args: {
						array1: [],
						array2: []
					},
					expect: {
						message: "",
						success: true,
						lengthsmatch: true,
						array1mismatchvalues: "",
						array2mismatchvalues: ""
					}
				},
				{
					name: "Array of components",
					args: {
						array1: [new mxunit.tests.samples.DataContainer().setA("a").setB(42).setC(true)],
						array2: [new mxunit.tests.samples.DataContainer().setA("b").setB(42).setC(true)]
					},
					expect: {
						message: "",
						success: false,
						lengthsmatch: true,
						array1mismatchvalues: 'Row 1, Object Compare Result: Structure path [ "a" ]: a',
						array2mismatchvalues: 'Row 1, Object Compare Result: Structure path [ "a" ]: b',
						'row 1': {
							message: "",
							success: false,
							UniqueToStruct1: "",
							UniqueToStruct2: "",
							mismatches: {
								'[ "a" ]': {
									Struct1Value: "a",
									Struct2Value: "b"
								}
							},
							Struct1MismatchValues: 'Structure path [ "a" ]: a',
							Struct2MismatchValues: 'Structure path [ "a" ]: b'
						}
					}
				},
				{
					name: "Keys of different types",
					args: {
						array1: ["a", {"b": "b"}],
						array2: ["a", "b"]
					},
					expect: {
						message: "Not sure how to compare these datatypes at row 2. File a bug with a patch. ",
						success: false,
						lengthsmatch: true,
						array1mismatchvalues: "row 2: CANNOT COMPARE TO ARRAY 2",
						array2mismatchvalues: "row 2: CANNOT COMPARE TO ARRAY 1"
					}
				}
			];
			var dc = new mxunit.framework.DataCompare();
			for (var test in tests) {
				try {
					var actual = dc.compareArrays(argumentCollection = test.args);
					// debug(actual);
					AssertEquals(test.expect, actual, test.name);
				} catch (any e) {
					debug(e);
					fail("#test.name#: unexpected exception. run w/ debug for details.");
				}
			}
		</cfscript>
	</cffunction>

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
					name: "Component values in keys",
					args: {
						struct1: {"cfc": new mxunit.tests.samples.DataContainer().setA("a").setB(42).setC(true)},
						struct2: {"cfc": new mxunit.tests.samples.DataContainer().setA("b").setB(42).setC(true)}
					},
					expect: {
						message: "",
						success: false,
						UniqueToStruct1: "",
						UniqueToStruct2: "",
						mismatches: {
							'[ "cfc" ]': {
								message: "",
								success: false,
								UniqueToStruct1: "",
								UniqueToStruct2: "",
								mismatches: {
									'[ "cfc" ][ "a" ]': {
										Struct1Value: "a",
										Struct2Value: "b"
									}
								},
								Struct1MismatchValues: 'Structure path [ "cfc" ][ "a" ]: a',
								Struct2MismatchValues: 'Structure path [ "cfc" ][ "a" ]: b'
							}
						},
						Struct1MismatchValues: 'Structure path [ "cfc" ][ "a" ]: a',
						Struct2MismatchValues: 'Structure path [ "cfc" ][ "a" ]: b'
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
						Struct1MismatchValues: 'Structure path [ "B" ]: CANNOT COMPARE TO STRUCT 2',
						Struct2MismatchValues: 'Structure path [ "B" ]: CANNOT COMPARE TO STRUCT 1'
					}
				}
			];
			var dc = new mxunit.framework.DataCompare();
			for (var test in tests) {
				try {
					var actual = dc.compareStructs(argumentCollection = test.args);
					// if ( test.name == "Component values in keys" ) {
					// 	debug(actual);
					// }
					AssertEquals(test.expect, actual, test.name);
				} catch (any e) {
					debug(e);
					fail("#test.name#: unexpected exception. run w/ debug for details.");
				}
			}
		</cfscript>
	</cffunction>

</cfcomponent>