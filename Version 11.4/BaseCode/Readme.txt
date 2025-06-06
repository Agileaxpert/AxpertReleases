Schema-Level Configuration Steps (Post IIS Setup for AxpertWeb, AxpertStudio, ARM, AgileConnect)

After completing the IIS setup for AxpertWeb, AxpertStudio, ARM, and AgileConnect, follow the steps below to configure schema-level settings:
 
1. Create AgileConnect Connection for the Schema
         a.Sign in to AgileConnect.
         b.Navigate to the App section and use the Create App option to set up a new AgileConnect connection for the required schema.
Note:
In the AxpertDB Details Section, ensure the AxpertScripts URL is set to the ARMScripts URL.
 
2. Configure ARM Connections
         a.Open the config.aspx page.
         b.Set up the appropriate ARM connections for the schema.
 
3. Register Schema in axapps.xml
         a.Navigate to the ARMScripts folder.
         b.Add the schema entry in the axapps.xml file.
 
4. Configure Import Data
         a.Open the config.aspx page.
         b.Set up the appropriate File Upload/Download Information for the schema.
 
5. Finalize Schema Setup
         a.Upon successful login to the schema, create or update the required Axvars and constants as needed.