# Release Notes

**Date:** 09/09/2026

This patch includes fixes and enhancements for the following issues:

### 1. TSK-0668 – Additional Details to be Returned by AxGet API

The **AxGet API** now returns the following additional nodes:

* `createdon`
* `createdby`
* `modifiedon`
* `modifiedby`

### 2. TKT-1066 – GetDataFromAxList Function Not Working as Expected

**Customer:** GI Staffing Services Private Limited

* Fixed the issue with the `GetDataFromAxList` function.

### 3. TSK-0688 – Provision to Update an Existing Record Without Using Record ID in AXPUT = true API

The **AXPUT API** has been enhanced to support updating existing records without requiring `axp_recid`.

* `keyfield`, `keyvalue`, and `axrow_action` are mandatory for each row.
* `axp_recid` is now optional.
* If `axp_recid` is provided, it must be valid; otherwise, it should be excluded.
* When `axp_recid` is not provided, `keyfield` and `keyvalue` are used to identify the existing record.
* The same `axp_recid` approach must be followed consistently across all DCSs and rows.

### 4. TSK-0698 – Data Not Saving with AXPUT = true Due to Validation Errors

The issue was reported when using the **CachedSave Consumer Worker Service**, where `AXPUT = true` invokes the ARM AxPut API.

The following issues have been fixed:

* **Date Validation:** Handled date validation using `ClientDateFormat` when fetching date values.
* **Numeric / ID Fields:** Handled Numeric and ID fields properly during MDMap execution for SQL-related operations.
* **Duplicate Check:** Fixed the Duplicate Check issue by handling the conditions properly.
* **Picklist Validation:** Fixed Picklist execution where valid data was incorrectly reported as an invalid selection.
* **Normalized Fields:** Reset `IDValue` properly during normalized field processing.
* **Multiple Picklist Fields:** Fixed the **"A command is already in progress"** error when multiple Picklist fields are processed sequentially by properly handling asynchronous execution using `await`.

# Release Notes

**Date:** 18/09/2026

This patch includes fixes and enhancements for the following issues:

### 1. TSK-0741 – AxPut: Enhance DateTime Handling in Core Methods

The **AxPut** date and time handling has been enhanced to ensure values are processed using the appropriate database formats.

- Introduced `ApiDateFormat` and `ApiTimeFormat` variables in the `ARMCommon` helper.
- Integrated the database date and time formats wherever required.

### 2. TSK-0723 – AXPUT – Record Identification and Validation

The **AXPUT API** record identification and validation logic has been enhanced to handle different combinations of `axp_recid`, `keyfield`, `keyvalue`, and `axrow_action`.

- **Invalid KeyField Error:** Updated AXPUT to return the DB error message when an invalid KeyField is provided.
- **Enhanced Record Identification:** Updated the handling of `axp_recid`, `keyfield`, and `keyvalue` based on the following scenarios:
  - If `axp_recid` exists but is empty, use `keyfield` and `keyvalue` for edit operations.
  - If `axp_recid` is `0` and `action = edit`, use `keyfield` and `keyvalue` to identify the record.
  - If `axp_recid` is `0` and `action = create`, process the request based on `axp_recid`, as applicable.
  - If `axp_recid` contains a valid Record ID and `action = edit`, update the record using `axp_recid`.
  - If `axp_recid` is not provided and `action = edit`, identify the record using `keyfield` and `keyvalue`.
  - If `axp_recid` is not provided and `action = create`, process the request using `keyfield` and `keyvalue`, as applicable.
  - Give first preference to `axp_recid` when it exists and contains a valid value.
  - Use `keyfield` and `keyvalue` when `axp_recid` is unavailable or not applicable.

### 3. TSK-0724 – AXPUT – Data Type and MDMap Verification

The **AXPUT API** MDMap and data type handling have been enhanced to resolve field mapping and date-related issues.

- **Duplicate Column Error:** Fixed the MDMap issue when the Update Field and Search Field are the same.
- **Fill and MDMap Date Mapping:** Fixed the date mapping issue in `getRowValue`.
- **Timestamp Handling:** Enhanced timestamp processing to save values using the appropriate database data type.

### 4. TSK-0698 – QA – Data Not Saving with AXPUT = true Due to Validation Error

Fixed the issue where data was not being saved with `AXPUT = true` due to a date validation error in the UAT2 schema during multi-transaction save.

- **Date Type Issue:** Fixed the parser's date function used in GenMap to ensure date values are processed correctly.

TKT-1277 -QA- Issue Description: In the Axpert flutter app, when a user tries to log in with any user account other than the Admin account, the application displays the following error: Application is not licensed.
