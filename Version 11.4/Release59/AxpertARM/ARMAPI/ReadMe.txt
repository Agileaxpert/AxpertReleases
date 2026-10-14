TSK-0802 – AxPut: Unable to Save Data with AxPut = true from Custom Page/Browser Console

Data could not be saved using AxPut = true when the transaction was triggered from a custom page or browser console. The same operation was working correctly when executed through Postman.

Cause:
During web login, the parser object was not being properly initialized with the required App and Global variables.

Fix:
Updated the parser creation logic in AxTstructData to properly assign the App and Global variables, ensuring that AxPut operations work correctly when invoked from custom pages or the browser console.

Note: The actual fix for this issue (TSK-0802) was already included in the previous release. However, this issue is related to another screen where the **Validate** operation fails. The details of the fixes for this issue are listed below.

* Fixed expression validation to use `fld.cexpr` instead of `fld.Exprn`.
* Added a `NOT NULL` check for picklist field `SQLResult`.
* Fixed the parser's `IsEmpty` check for the internal `~e~` value, following the existing Delphi implementation.
* Implemented Genmap control field handling.
* Fixed issues with multiple Genmaps sharing the same `Transid`.

Note: Redis must be cleared after applying this fix due to changes in `StructDef` serialization.